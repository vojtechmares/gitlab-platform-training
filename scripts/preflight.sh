#!/usr/bin/env bash
# Checks everything that can be checked BEFORE "terraform apply", using your Hetzner token
# read-only. It creates nothing. Run it from the repository root, or anywhere:
#
#   export HCLOUD_TOKEN=<token>          # or TF_VAR_hcloud_token, or hcloud_token in terraform.tfvars
#   scripts/preflight.sh
#
# What it verifies
#   - Terraform (or OpenTofu) is new enough
#   - the SSH public key file exists and is a real key
#   - the token works
#   - the image (default debian-13) exists for x86
#   - each server type exists, is not deprecated, and is offered in your location
#   - nothing with the same names already exists in the project (a second apply would collide)
#
# It does not prove the token has WRITE permission: Hetzner offers no read-only way to test that.
# Create the token with "Read & Write" (Security > API tokens in the project).
#
# With cloudflare_zone set it also checks, read-only, the Cloudflare token, the zone, that gitlab.<base_domain> and
# registry.<base_domain> do not exist yet (Cloudflare accepts duplicate A records), and CAA records.
#
# Settings are read from the environment (TF_VAR_<name>), then from infrastructure/*.auto.tfvars and
# infrastructure/terraform.tfvars (the same precedence Terraform uses), falling back to the defaults of
# infrastructure/variables.tf. Test overrides: HCLOUD_API_URL, CLOUDFLARE_API_URL, CURL_EXTRA.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="${TF_DIR:-${HERE}/../infrastructure}"
API="${HCLOUD_API_URL:-https://api.hetzner.cloud/v1}"

# --- settings --------------------------------------------------------------------------------
tfvar() { # tfvar NAME  -> environment, then *.auto.tfvars (last wins), then terraform.tfvars, then the default in variables.tf
  local name="$1" env_name value file
  env_name="TF_VAR_${name}"
  if [ -n "${!env_name:-}" ]; then printf '%s' "${!env_name}"; return; fi
  # Highest precedence first: *.auto.tfvars in reverse alphabetical order, then terraform.tfvars.
  for file in $(ls -r "${TF_DIR}"/*.auto.tfvars 2>/dev/null) "${TF_DIR}/terraform.tfvars"; do
    [ -f "${file}" ] || continue
    value="$(sed -nE "s/^[[:space:]]*${name}[[:space:]]*=[[:space:]]*\"?([^\"#]*)\"?.*/\1/p" "${file}" | head -1 | sed -E 's/[[:space:]]+$//')"
    if [ -n "${value}" ]; then printf '%s' "${value}"; return; fi
  done
  # default = "x" or default = true/false inside the variable "name" block
  awk -v n="${name}" '
    $0 ~ "^variable \"" n "\"" { inblock = 1; next }
    inblock && /^}/ { inblock = 0 }
    inblock && /^[[:space:]]*default[[:space:]]*=/ {
      sub(/^[[:space:]]*default[[:space:]]*=[[:space:]]*/, ""); gsub(/"/, ""); print; exit }
  ' "${TF_DIR}/variables.tf"
}

TOKEN="${HCLOUD_TOKEN:-$(tfvar hcloud_token)}"
LOCATION="$(tfvar location)"
IMAGE="$(tfvar image)"
PREFIX="$(tfvar name_prefix)"
DEPLOY="$(tfvar enable_deploy_host)"
KEY_FILE="$(tfvar ssh_public_key_file)"
KEY_FILE="${KEY_FILE/#\~/${HOME}}"
EXISTING_KEY="$(tfvar existing_ssh_key_name)"
BASE_DOMAIN="$(tfvar base_domain)"
CF_ZONE="$(tfvar cloudflare_zone)"
CF_TOKEN="${CLOUDFLARE_API_TOKEN:-$(tfvar cloudflare_api_token)}"
CF_API="${CLOUDFLARE_API_URL:-https://api.cloudflare.com/client/v4}"
TYPES=("$(tfvar gitlab_server_type)" "$(tfvar runner_server_type)")
[ "${DEPLOY}" = "true" ] && TYPES+=("$(tfvar deploy_server_type)")

pass=0
fail=0
ok() { printf '  ok    %s\n' "$1"; pass=$((pass + 1)); }
bad() { printf '  FAIL  %s\n' "$1"; fail=$((fail + 1)); }
warn() { printf '  note  %s\n' "$1"; }

API_STATUS=000
API_BODY=""
# shellcheck disable=SC2086 # CURL_EXTRA is meant to word-split into flags
call() { # call PATH -> sets API_BODY and API_STATUS (not run in a subshell, so they survive)
  local out
  API_BODY=""
  API_STATUS=000
  out="$(curl -sS -m 30 ${CURL_EXTRA:-} -H "Authorization: Bearer ${TOKEN}" -w '\n%{http_code}' "${API}/$1" 2>/dev/null)" || return 1
  API_STATUS="${out##*$'\n'}"
  API_BODY="${out%$'\n'*}"
}

echo "Location ${LOCATION}, image ${IMAGE}, prefix ${PREFIX}, server types: ${TYPES[*]}"
echo
echo "Local tools"
if command -v terraform >/dev/null 2>&1 || command -v tofu >/dev/null 2>&1; then
  tool="$(command -v terraform || command -v tofu)"
  version="$("${tool}" version -json 2>/dev/null | jq -r '.terraform_version // empty' 2>/dev/null)"
  [ -z "${version}" ] && version="$("${tool}" version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
  if [ -n "${version}" ] && [ "$(printf '%s\n1.6.0\n' "${version}" | sort -V | head -1)" = "1.6.0" ]; then ok "$(basename "${tool}") ${version} (needs 1.6.0 or newer)"; else bad "$(basename "${tool}") ${version:-unknown}: version 1.6.0 or newer is required"; fi
else
  bad "neither terraform nor tofu is installed"
fi
for tool in curl jq; do
  if command -v "${tool}" >/dev/null 2>&1; then ok "${tool} is installed"; else bad "${tool} is not installed"; fi
done
if [ -f "${KEY_FILE}" ] && ssh-keygen -l -f "${KEY_FILE}" >/dev/null 2>&1; then
  ok "SSH public key ${KEY_FILE}: $(ssh-keygen -l -f "${KEY_FILE}" | awk '{print $4, $1, $2}')"
else
  bad "SSH public key file ${KEY_FILE} is missing or is not a public key (set ssh_public_key_file)"
fi

echo "Hetzner Cloud (read-only)"
if [ -z "${TOKEN}" ]; then
  bad "no token: set HCLOUD_TOKEN, TF_VAR_hcloud_token or hcloud_token in terraform.tfvars"
else
  if [ "${#TOKEN}" -ne 64 ]; then bad "the token is ${#TOKEN} characters long, Hetzner tokens have exactly 64"; fi
  call "locations?name=${LOCATION}"; body="${API_BODY}"
  case "${API_STATUS}" in
    200)
      ok "the token works"
      if [ "$(jq -r '.locations | length' <<<"${body}")" -ge 1 ]; then ok "location ${LOCATION} exists ($(jq -r '.locations[0].city' <<<"${body}"))"; else bad "location ${LOCATION} does not exist"; fi
      ;;
    401 | 403) bad "Hetzner rejected the token (HTTP ${API_STATUS}): wrong token, or from another project" ;;
    000) bad "could not reach ${API}" ;;
    *) bad "unexpected answer from the API: HTTP ${API_STATUS}" ;;
  esac

  if [ "${API_STATUS}" = "200" ]; then
    call "images?name=${IMAGE}&architecture=x86&type=system"; body="${API_BODY}"
    if [ "$(jq -r '.images | length' <<<"${body}" 2>/dev/null)" -ge 1 ] 2>/dev/null; then
      ok "image ${IMAGE} exists for x86 ($(jq -r '.images[0].description' <<<"${body}"))"
    else
      bad "image ${IMAGE} does not exist for x86 (try: debian-13, ubuntu-24.04)"
    fi

    for type in $(printf '%s\n' "${TYPES[@]}" | sort -u); do
      call "server_types?name=${type}"; body="${API_BODY}"
      if [ "$(jq -r '.server_types | length' <<<"${body}" 2>/dev/null)" -lt 1 ] 2>/dev/null; then
        bad "server type ${type} does not exist"
        continue
      fi
      summary="$(jq -r '.server_types[0] | "\(.cores) vCPU, \(.memory) GB RAM, \(.architecture)"' <<<"${body}")"
      if jq -e --arg l "${LOCATION}" '.server_types[0].prices | map(.location) | index($l)' <<<"${body}" >/dev/null 2>&1; then
        if jq -e '.server_types[0].deprecation != null' <<<"${body}" >/dev/null 2>&1; then
          bad "server type ${type} is deprecated: $(jq -r '.server_types[0].deprecation.announced' <<<"${body}")"
        elif jq -e --arg l "${LOCATION}" '.server_types[0].locations // [] | map(select(.name == $l and .available == false)) | length > 0' <<<"${body}" >/dev/null 2>&1; then
          # "offered" is not "in stock": creating the server fails with resource_unavailable (error during placement)
          bad "server type ${type} (${summary}) is offered in ${LOCATION} but has NO CAPACITY right now (resource_unavailable). In stock now: $(jq -r '.server_types[0].locations | map(select(.available)) | map(.name) | join(", ") | if . == "" then "nowhere" else . end' <<<"${body}"). Pick another type or location"
        else
          ok "server type ${type} (${summary}) is offered in ${LOCATION} and in stock"
        fi
      else
        bad "server type ${type} is NOT offered in ${LOCATION}; it is offered in: $(jq -r '.server_types[0].prices | map(.location) | join(", ")' <<<"${body}")"
      fi
    done

    echo "Name collisions in this project"
    collisions=0
    for item in "servers:${PREFIX}-gitlab" "servers:${PREFIX}-runner" "servers:${PREFIX}-deploy" \
      "primary_ips:${PREFIX}-gitlab-v4" "primary_ips:${PREFIX}-runner-v4" "primary_ips:${PREFIX}-deploy-v4" \
      "firewalls:${PREFIX}-gitlab" "firewalls:${PREFIX}-runner" "firewalls:${PREFIX}-deploy" "ssh_keys:${PREFIX}-admin"; do
      kind="${item%%:*}"
      name="${item#*:}"
      call "${kind}?name=${name}"; body="${API_BODY}"
      if [ "${API_STATUS}" = "200" ] && [ "$(jq -r --arg k "${kind}" '.[$k] | length' <<<"${body}")" -ge 1 ]; then
        bad "a ${kind%s} named ${name} already exists (use another name_prefix, or remove it)"
        collisions=$((collisions + 1))
      fi
    done
    [ "${collisions}" -eq 0 ] && ok "no server, address, firewall or key with these names exists yet"

    # Hetzner also refuses a public key whose FINGERPRINT is already in the project, under any name.
    if [ -f "${KEY_FILE}" ] && [ -z "${EXISTING_KEY}" ]; then
      fingerprint="$(ssh-keygen -l -E md5 -f "${KEY_FILE}" 2>/dev/null | awk '{print $2}' | sed 's/^MD5://')"
      call "ssh_keys?fingerprint=${fingerprint}"; body="${API_BODY}"
      if [ "${API_STATUS}" = "200" ] && [ "$(jq -r '.ssh_keys | length' <<<"${body}")" -ge 1 ]; then
        bad "this SSH key is already in the project as \"$(jq -r '.ssh_keys[0].name' <<<"${body}")\": Hetzner rejects a second upload. Set existing_ssh_key_name = \"$(jq -r '.ssh_keys[0].name' <<<"${body}")\""
      else
        ok "the SSH key is not in the project yet, so Terraform can upload it"
      fi
    fi
  fi
fi

if [ -n "${CF_ZONE}" ]; then
  echo "Cloudflare DNS (read-only)"
  cf_call() { # cf_call PATH -> sets CF_BODY and CF_STATUS
    local out
    CF_BODY=""
    CF_STATUS=000
    # shellcheck disable=SC2086 # CURL_EXTRA is meant to word-split into flags
    out="$(curl -sS -m 30 ${CURL_EXTRA:-} -H "Authorization: Bearer ${CF_TOKEN}" -w '\n%{http_code}' "${CF_API}/$1" 2>/dev/null)" || return 1
    CF_STATUS="${out##*$'\n'}"
    CF_BODY="${out%$'\n'*}"
  }
  cf_ready=1
  if [ -z "${BASE_DOMAIN}" ]; then bad "cloudflare_zone is set but base_domain is empty"; cf_ready=0
  elif [ "${BASE_DOMAIN}" != "${CF_ZONE}" ] && [ "${BASE_DOMAIN%."${CF_ZONE}"}" = "${BASE_DOMAIN}" ]; then
    bad "base_domain ${BASE_DOMAIN} is not ${CF_ZONE} or a subdomain of it"; cf_ready=0
  fi
  if [ -z "${CF_TOKEN}" ]; then
    bad "no Cloudflare token: set cloudflare_api_token (or CLOUDFLARE_API_TOKEN)"; cf_ready=0
  elif printf '%s' "${CF_TOKEN}" | grep -qE '^[0-9a-f]{32}$'; then
    bad "the Cloudflare value is 32 hex characters: that is the shape of a zone or account ID. API tokens are 40 characters (My Profile > API Tokens)"; cf_ready=0
  fi
  if [ "${cf_ready}" -eq 1 ]; then
    cf_call "zones?name=${CF_ZONE}"
    case "${CF_STATUS}" in
      200)
        zone_id="$(jq -r '.result[0].id // empty' <<<"${CF_BODY}")"
        if [ -n "${zone_id}" ]; then
          ok "the token works and can read zone ${CF_ZONE} (status: $(jq -r '.result[0].status' <<<"${CF_BODY}"))"
          for fqdn in "gitlab.${BASE_DOMAIN}" "registry.${BASE_DOMAIN}"; do
            cf_call "zones/${zone_id}/dns_records?name=${fqdn}"
            existing="$(jq -r '.result | map("\(.type) \(.content)") | join(", ")' <<<"${CF_BODY}" 2>/dev/null)"
            if [ "${CF_STATUS}" != "200" ]; then bad "could not list DNS records of ${fqdn} (HTTP ${CF_STATUS}): the token needs Zone > DNS > Edit"
            elif [ -n "${existing}" ]; then bad "${fqdn} already has a record (${existing}); Cloudflare would keep both and answer round-robin. Remove it first"
            else ok "no record named ${fqdn} exists yet"
            fi
          done
        else
          bad "the token works but zone ${CF_ZONE} is not visible to it (wrong account, or the token is scoped to another zone)"
        fi
        ;;
      400 | 401 | 403) bad "Cloudflare rejected the token (HTTP ${CF_STATUS}): $(jq -r '[.errors[]?.message] | join("; ")' <<<"${CF_BODY}" 2>/dev/null)" ;;
      000) bad "could not reach ${CF_API}" ;;
      *) bad "unexpected answer from Cloudflare: HTTP ${CF_STATUS}" ;;
    esac
    if command -v dig >/dev/null 2>&1; then
      caa="$(dig +short CAA "${BASE_DOMAIN}" 2>/dev/null)"
      if [ -z "${caa}" ]; then ok "no CAA records: any certificate authority may issue"
      elif grep -qi 'letsencrypt.org' <<<"${caa}"; then
        ok "CAA allows Let's Encrypt"
        grep -qi 'sectigo\|zerossl' <<<"${caa}" || warn "CAA does not allow ZeroSSL, so Caddy's fallback authority cannot issue; only Let's Encrypt can"
      else bad "CAA records exist and do not allow letsencrypt.org: ${caa//$'\n'/; }"
      fi
    fi
  fi
fi

warn "not checked: that the Hetzner token can write (create it as Read & Write), that the Cloudflare token can edit DNS (only a write proves it), and Let's Encrypt"
echo
echo "${pass} passed, ${fail} failed"
[ "${fail}" -eq 0 ]
