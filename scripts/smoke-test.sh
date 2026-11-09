#!/usr/bin/env bash
# Smoke test for the training infrastructure, run from your laptop after "terraform apply".
#
#   scripts/smoke-test.sh
#
# Reads addresses from "terraform output". Optional: export GITLAB_TOKEN (a personal access
# token of an administrator, scope "api") to also check the runner, sign-up, and to
# lint the example pipelines on the real server (a throwaway project is created and removed).
# Needs: terraform, curl, jq, ssh-keyscan.
#
# Overrides for testing against something else: GITLAB_URL, REGISTRY_HOST, GITLAB_IP,
# RUNNER_IP, DEPLOY_IP, SSH_PORT, DEPLOY_KEY_FILE, CURL_EXTRA (extra curl flags, for example "-k").
#
# The CI Lint part skips examples it cannot resolve yet: the component example is skipped until
# scripts/seed-training-data.sh has created training/ci-components. Run this script again after seeding.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="${TF_DIR:-${HERE}/../infrastructure}"
EXAMPLES_DIR="${EXAMPLES_DIR:-${HERE}/../examples}"

tf() { terraform -chdir="${TF_DIR}" output "$@"; }

GITLAB_URL="${GITLAB_URL:-$(tf -raw gitlab_url)}"
REGISTRY_HOST="${REGISTRY_HOST:-$(tf -raw registry_host)}"
GITLAB_IP="${GITLAB_IP:-$(tf -json ip_addresses | jq -r .gitlab)}"
RUNNER_IP="${RUNNER_IP:-$(tf -json ip_addresses | jq -r .runner)}"
DEPLOY_IP="${DEPLOY_IP-$(tf -json ip_addresses | jq -r '.deploy // empty')}"
SSH_PORT="${SSH_PORT:-$(tf -raw ssh_port)}"

pass=0
fail=0
known_hosts="$(mktemp)"
lint_project=""
cleanup() {
  rm -f "${known_hosts}"
  if [ -n "${lint_project}" ] && [ -n "${GITLAB_TOKEN:-}" ]; then
    api "projects/${lint_project}" -X DELETE >/dev/null 2>&1 || true
    # The first call only marks the project and RENAMES its path (...-deletion_scheduled-<id>); the permanent
    # removal must name the path as it is now.
    scheduled_path="$(api "projects/${lint_project}" 2>/dev/null | jq -r '.path_with_namespace // empty' 2>/dev/null || true)"
    api "projects/${lint_project}?permanently_remove=true&full_path=${scheduled_path:-${lint_project_path}}" -X DELETE >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT
lint_project_path=""
check() { # check "description" command [args...]
  local description="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    printf '  ok    %s\n' "${description}"
    pass=$((pass + 1))
  else
    printf '  FAIL  %s\n' "${description}"
    fail=$((fail + 1))
  fi
}

# shellcheck disable=SC2086 # CURL_EXTRA is meant to word-split into flags
curl_() { curl -sS -m 30 ${CURL_EXTRA:-} "$@"; }

http_status_is() { [ "$(curl_ -o /dev/null -w '%{http_code}' "$2")" = "$1" ]; } # EXPECTED URL
host_key() { ssh-keyscan -T 10 -p "$1" "$2" 2>/dev/null | awk '$2=="ssh-ed25519"{print $3}'; }
has_host_key() { [ -n "$(host_key "$1" "$2")" ]; } # PORT HOST
keys_differ() { # PORT_A PORT_B HOST: two different sshd instances answer
  local a b
  a="$(host_key "$1" "$3")"
  b="$(host_key "$2" "$3")"
  [ -n "${a}" ] && [ -n "${b}" ] && [ "${a}" != "${b}" ]
}

ssh_as() { # ssh_as USER HOST command... (key-only, throwaway known_hosts file, never prompts)
  local user="$1" host="$2" key_args=()
  shift 2
  [ -n "${SSH_KEY_FILE:-}" ] && key_args=(-i "${SSH_KEY_FILE}" -o IdentitiesOnly=yes)
  ssh "${key_args[@]}" -o BatchMode=yes -o ConnectTimeout=10 -o UserKnownHostsFile="${known_hosts}" \
    -o StrictHostKeyChecking=accept-new -p "${SSH_PORT}" "${user}@${host}" "$@"
}
can_login() { ssh_as root "$1" true; } # HOST: your own key logs in as root
deploy_key_works() { # HOST: the generated deploy key logs in as "deploy" and may use Docker
  local key rc
  key="$(mktemp)"
  chmod 600 "${key}"
  if [ -n "${DEPLOY_KEY_FILE:-}" ]; then cat "${DEPLOY_KEY_FILE}" >"${key}"; else tf -raw deploy_ssh_private_key >"${key}"; fi
  SSH_KEY_FILE="${key}" ssh_as deploy "$1" docker version --format '{{.Server.Version}}'
  rc=$?
  rm -f "${key}"
  return "${rc}"
}

api() { # api PATH [curl args...]
  local path="$1"
  shift
  curl_ -f -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${GITLAB_URL}/api/v4/${path}" "$@"
}
runner_online() { api 'runners/all?status=online' | jq -e 'length > 0'; }
signup_disabled() { api application/settings | jq -e '.signup_enabled == false'; }
lint_file() { # lint_file PROJECT_ID FILE
  jq -n --rawfile content "$2" '{content: $content}' \
    | api "projects/$1/ci/lint" -H 'Content-Type: application/json' -d @- \
    | jq -e '.valid == true'
}

echo "GitLab    ${GITLAB_URL}"
echo "Registry  ${REGISTRY_HOST}"
echo
echo "Web and registry"
check "sign-in page answers 200 over HTTPS (certificate is trusted)" http_status_is 200 "${GITLAB_URL}/users/sign_in"
check "registry answers 401 to anonymous /v2/ (it exists and wants a login)" http_status_is 401 "https://${REGISTRY_HOST}/v2/"
check "plain HTTP redirects to HTTPS" http_status_is 308 "http://${GITLAB_IP}/"

echo "SSH"
check "port 22 on the GitLab VM answers (Git over SSH)" has_host_key 22 "${GITLAB_IP}"
check "host sshd answers on ${SSH_PORT}" has_host_key "${SSH_PORT}" "${GITLAB_IP}"
check "port 22 and ${SSH_PORT} are different servers (GitLab vs host sshd)" keys_differ 22 "${SSH_PORT}" "${GITLAB_IP}"
check "runner VM sshd answers on ${SSH_PORT}" has_host_key "${SSH_PORT}" "${RUNNER_IP}"
check "you can log in to the GitLab VM as root (key only)" can_login "${GITLAB_IP}"
check "you can log in to the runner VM as root" can_login "${RUNNER_IP}"
if [ -n "${DEPLOY_IP}" ]; then
  check "deploy VM sshd answers on ${SSH_PORT}" has_host_key "${SSH_PORT}" "${DEPLOY_IP}"
  check "you can log in to the deploy VM as root" can_login "${DEPLOY_IP}"
  check "the deploy key logs in as 'deploy' and can use Docker" deploy_key_works "${DEPLOY_IP}"
fi

if [ -n "${GITLAB_TOKEN:-}" ]; then
  echo "API (administrator token)"
  check "token works" api user
  check "at least one runner is online" runner_online
  check "sign-up is disabled" signup_disabled

  echo "CI Lint of the examples (on the real server)"
  lint_name="smoke-test-lint-$$-${RANDOM}"
  created="$(api projects -X POST --data-urlencode "name=${lint_name}" --data visibility=private 2>/dev/null || true)"
  lint_project="$(jq -r '.id // empty' <<<"${created}" 2>/dev/null)"
  lint_project_path="$(jq -r '.path_with_namespace // empty' <<<"${created}" 2>/dev/null)"
  if [ -z "${lint_project}" ]; then
    echo "  FAIL  could not create a throwaway project for linting"
    fail=$((fail + 1))
  else
    components_ready=0
    api 'projects/training%2Fci-components' >/dev/null 2>&1 && components_ready=1
    while IFS= read -r file; do
      name="${file#"${EXAMPLES_DIR}"/}"
      # Review exercises are broken on purpose (they include a URL that does not exist): never lint them.
      if grep -q '^# EXERCISE' "${file}"; then
        printf '  skip  %s (a review exercise with deliberate problems)\n' "${name}"
      # Not lintable in an empty project: files that include local files, or trigger a child pipeline file.
      elif grep -qE 'local:|^[[:space:]]*trigger:' "${file}"; then
        printf '  skip  %s (needs files from its own repository)\n' "${name}"
      elif grep -q 'component:' "${file}" && [ "${components_ready}" -eq 0 ]; then
        printf '  skip  %s (run scripts/seed-training-data.sh first, then this script again)\n' "${name}"
      else
        check "valid: ${name}" lint_file "${lint_project}" "${file}"
      fi
    done < <(find "${EXAMPLES_DIR}" \( -name '.gitlab-ci.yml' -o -name 'step*.yml' \) -type f | sort)
  fi
else
  echo
  echo "(set GITLAB_TOKEN to an administrator's personal access token to also check the runner and lint the examples)"
fi

echo
echo "${pass} passed, ${fail} failed"
[ "${fail}" -eq 0 ]
