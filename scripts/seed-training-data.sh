#!/usr/bin/env bash
# Prepare a fresh training instance: accounts, a template application, a component library,
# and the CI/CD variables the Day 2 deploy pipeline needs. Safe to run again.
#
#   export GITLAB_TOKEN=<personal access token of the administrator, scope "api">
#   scripts/seed-training-data.sh
#
# Creates
#   - persona accounts alice (developer), bob (maintainer), carol (auditor), dave (contractor)
#     for the permission lab, and trainee1..N for the participants (regular users)
#   - group "training" with three internal projects participants clone, fork or consume:
#       training/git-exercises   practice scenarios for the Git blocks (without the trainer's solutions/)
#       training/hello-app       the sample application (no pipeline yet) and ci-steps/
#       training/ci-components   reusable CI/CD components, released as 1.0.0
#   - instance-level CI/CD variables for the deploy pipeline (from "terraform output")
#   - training-accounts.txt (git-ignored) with every login
#
# Settings (environment): GITLAB_URL, TRAINEES (default 4), TF_DIR, CURL_EXTRA,
#   SKIP_DEPLOY_VARS=1 to leave out the deploy variables, TRAINING_DOMAIN (e-mail domain).
# Needs: curl, jq, base64, openssl; terraform and ssh-keyscan for the deploy variables.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="${TF_DIR:-${HERE}/../infrastructure}"
EXAMPLES_DIR="${EXAMPLES_DIR:-${HERE}/../examples}"
TRAINEES="${TRAINEES:-4}"
TRAINING_DOMAIN="${TRAINING_DOMAIN:-training.invalid}"
ACCOUNTS_FILE="${ACCOUNTS_FILE:-${HERE}/../training-accounts.txt}"

: "${GITLAB_TOKEN:?Set GITLAB_TOKEN to a personal access token of an administrator (scope api)}"
GITLAB_URL="${GITLAB_URL:-$(terraform -chdir="${TF_DIR}" output -raw gitlab_url)}"
API="${GITLAB_URL%/}/api/v4"

log() { printf '==> %s\n' "$*" >&2; }

# shellcheck disable=SC2086 # CURL_EXTRA is meant to word-split into flags
call() { # call METHOD PATH [curl args...] - prints the body, returns non-zero on HTTP errors
  local method="$1" path="$2"
  shift 2
  curl -sS -f -m 120 ${CURL_EXTRA:-} -X "${method}" -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${API}/${path}" "$@"
}

# Passwords must pass GitLab's strength check ("commonly used combinations" are refused).
random_password() { printf '%s-%s' "$(LC_ALL=C tr -dc 'A-HJ-NP-Za-km-z2-9' </dev/urandom | head -c 16)" "$(LC_ALL=C tr -dc '2-9' </dev/urandom | head -c 3)"; }

declare -a ACCOUNT_LINES=()

ensure_user() { # ensure_user USERNAME "Full Name" ROLE_NOTE
  local username="$1" name="$2" note="$3" id password attempt
  id="$(call GET "users?username=${username}" | jq -r '.[0].id // empty')"
  if [ -n "${id}" ]; then
    log "user ${username} exists"
    ACCOUNT_LINES+=("${username} | (unchanged, created earlier) | ${note}")
    return
  fi
  for attempt in 1 2 3 4 5; do
    password="$(random_password)"
    if call POST users \
      --data-urlencode "username=${username}" --data-urlencode "name=${name}" \
      --data-urlencode "email=${username}@${TRAINING_DOMAIN}" --data-urlencode "password=${password}" \
      --data "skip_confirmation=true" --data "projects_limit=100" >/dev/null 2>&1; then
      log "created user ${username}"
      ACCOUNT_LINES+=("${username} | ${password} | ${note}")
      return
    fi
    log "user ${username}: password rejected or request failed (attempt ${attempt}), retrying"
  done
  echo "could not create user ${username}" >&2
  return 1
}

ensure_group() { # ensure_group PATH NAME -> prints id
  local path="$1" name="$2" id
  id="$(call GET "groups/${path}" 2>/dev/null | jq -r '.id // empty' || true)"
  if [ -z "${id}" ]; then
    id="$(call POST groups --data-urlencode "name=${name}" --data-urlencode "path=${path}" --data visibility=internal | jq -r .id)"
    log "created group ${path}"
  fi
  echo "${id}"
}

ensure_project() { # ensure_project GROUP_ID NAME DESCRIPTION -> prints id
  local group_id="$1" name="$2" description="$3" id
  id="$(call GET "projects?search=${name}&search_namespaces=false" | jq -r --arg n "${name}" --argjson g "${group_id}" '.[] | select(.name==$n and .namespace.id==$g) | .id' | head -1)"
  if [ -z "${id}" ]; then
    id="$(call POST projects --data-urlencode "name=${name}" --data-urlencode "description=${description}" \
      --data "namespace_id=${group_id}" --data visibility=internal --data default_branch=main | jq -r .id)"
    log "created project ${name}"
  fi
  echo "${id}"
}

seed_files() { # seed_files PROJECT_ID SOURCE_DIR "commit message"  (skips when the project already has commits)
  local project_id="$1" source_dir="$2" message="$3" actions
  if [ "$(call GET "projects/${project_id}/repository/commits?per_page=1" | jq 'length')" != "0" ]; then
    log "project ${project_id} already has content, leaving it alone"
    return
  fi
  actions="$(
    cd "${source_dir}"
    find . -type f \( -path './.git' -o -name '__pycache__' -o -name '*.pyc' -o -name '.DS_Store' \) -prune -o -type f -print | sort | while IFS= read -r file; do
      jq -n --arg path "${file#./}" --arg content "$(base64 <"${file}" | tr -d '\n')" \
        '{action: "create", file_path: $path, content: $content, encoding: "base64"}'
    done | jq -s .
  )"
  jq -n --arg message "${message}" --argjson actions "${actions}" \
    '{branch: "main", commit_message: $message, actions: $actions}' \
    | call POST "projects/${project_id}/repository/commits" -H 'Content-Type: application/json' -d @- >/dev/null
  log "committed $(jq length <<<"${actions}") files to project ${project_id}"
}

set_instance_variable() { # set_instance_variable KEY VALUE TYPE PROTECTED
  local key="$1" value="$2" type="$3" protected="$4"
  if ! call POST admin/ci/variables --data-urlencode "key=${key}" --data-urlencode "value=${value}" \
    --data "variable_type=${type}" --data "protected=${protected}" >/dev/null 2>&1; then
    call PUT "admin/ci/variables/${key}" --data-urlencode "value=${value}" \
      --data "variable_type=${type}" --data "protected=${protected}" >/dev/null
  fi
  log "instance variable ${key} set"
}

# --- 1. Accounts ---------------------------------------------------------------------------
call GET user >/dev/null || { echo "The token does not work against ${GITLAB_URL}" >&2; exit 1; }

ensure_user alice "Alice Developer" "persona: Developer"
ensure_user bob "Bob Maintainer" "persona: Maintainer"
ensure_user carol "Carol Auditor" "persona: Reporter"
ensure_user dave "Dave Contractor" "persona: Guest, external"
for i in $(seq 1 "${TRAINEES}"); do
  ensure_user "trainee${i}" "Trainee ${i}" "participant"
done

# --- 2. Shared projects --------------------------------------------------------------------
training_group="$(ensure_group training "Training")"

# Practice scenarios for Chapters 1 and 2. The reference solutions and the checker stay with the trainer.
exercises_id="$(ensure_project "${training_group}" git-exercises "Practice scenarios for the Git blocks (Chapters 1 and 2).")"
stage_ex="$(mktemp -d)"
stage="$(mktemp -d)"
trap 'rm -rf "${stage}" "${stage_ex}"' EXIT
cp -R "${EXAMPLES_DIR}/git-exercises/." "${stage_ex}/"
rm -rf "${stage_ex}/solutions" "${stage_ex}/verify-all.sh"
seed_files "${exercises_id}" "${stage_ex}" "Initial import of the practice scenarios [ci skip]"

app_id="$(ensure_project "${training_group}" hello-app "Sample application. Fork it in Chapter 4.")"
# The template has NO pipeline on purpose: Chapters 6-8 build it up from ci-steps/.
cp -R "${EXAMPLES_DIR}/hello-app/." "${stage}/"
mkdir -p "${stage}/ci-steps"
cp "${EXAMPLES_DIR}"/ci/step*.yml "${stage}/ci-steps/"
cp -R "${EXAMPLES_DIR}/ci/step4-include" "${EXAMPLES_DIR}/ci/step7-child" "${stage}/ci-steps/"
seed_files "${app_id}" "${stage}" "Initial import of the sample application [ci skip]"

components_id="$(ensure_project "${training_group}" ci-components "Reusable CI/CD components (Chapter 7).")"
# No "[ci skip]" here: the tag below points at this commit, and GitLab skips the tag pipeline of a commit whose message
# says so. Then the release job never runs and the 1.0.0 release (Chapter 7) is never created.
seed_files "${components_id}" "${EXAMPLES_DIR}/ci/components" "Initial import of the CI/CD components"
if ! call GET "projects/${components_id}/repository/tags/1.0.0" >/dev/null 2>&1; then
  call POST "projects/${components_id}/repository/tags" --data tag_name=1.0.0 --data ref=main \
    --data-urlencode "message=First release of the components" >/dev/null
  log "tagged ci-components 1.0.0 (its pipeline creates the release)"
fi

# --- 3. Deploy variables for Chapter 7 ---------------------------------------------------------
if [ "${SKIP_DEPLOY_VARS:-0}" != "1" ]; then
  if target="$(terraform -chdir="${TF_DIR}" output -json deploy_target 2>/dev/null)" && [ "${target}" != "null" ]; then
    host="$(jq -r .host <<<"${target}")"
    port="$(jq -r .ssh_port <<<"${target}")"
    user="$(jq -r .user <<<"${target}")"
    known_hosts="$(ssh-keyscan -T 15 -p "${port}" "${host}" 2>/dev/null || true)"
    if [ -z "${known_hosts}" ]; then
      echo "WARNING: could not read the deploy host's SSH keys yet (still booting?). Run this script again later." >&2
    else
      set_instance_variable DEPLOY_HOST "${host}" env_var false
      set_instance_variable DEPLOY_SSH_PORT "${port}" env_var false
      set_instance_variable DEPLOY_USER "${user}" env_var false
      set_instance_variable SSH_KNOWN_HOSTS "${known_hosts}" env_var false
      # The trailing newline matters: $(...) strips it, and OpenSSH refuses a private key file without one
      # ("Load key: error in libcrypto"). A File variable is written to disk exactly as stored.
      set_instance_variable SSH_PRIVATE_KEY "$(terraform -chdir="${TF_DIR}" output -raw deploy_ssh_private_key)"$'\n' file true
    fi
  else
    log "no deploy host in the Terraform outputs, skipping the deploy variables"
  fi
fi

# --- 4. Hand-out ---------------------------------------------------------------------------
# A re-run must not lose the passwords of earlier runs: GitLab never shows them again. For an account that already
# existed, keep the line of the previous file when it holds a real password.
previous=""
[ -f "${ACCOUNTS_FILE}" ] && previous="$(cat "${ACCOUNTS_FILE}")"
{
  echo "GitLab: ${GITLAB_URL}"
  echo "username | password | note"
  for line in "${ACCOUNT_LINES[@]}"; do
    case "${line}" in
      *"(unchanged, created earlier)"*)
        old="$(grep -m1 -F "${line%% | *} | " <<<"${previous}" | grep -v '(unchanged' || true)"
        printf '%s\n' "${old:-${line}}"
        ;;
      *) printf '%s\n' "${line}" ;;
    esac
  done
} >"${ACCOUNTS_FILE}.new"
mv "${ACCOUNTS_FILE}.new" "${ACCOUNTS_FILE}"
chmod 600 "${ACCOUNTS_FILE}"
log "logins written to ${ACCOUNTS_FILE}"
cat "${ACCOUNTS_FILE}"
