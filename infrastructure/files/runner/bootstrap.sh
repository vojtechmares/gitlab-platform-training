#!/usr/bin/env bash
# Create an instance runner through the GitLab API and register this VM as its executor.
# Runs as training-runner-bootstrap.service; safe to run repeatedly.
set -euo pipefail

# shellcheck disable=SC1091
source /etc/training/env

CONFIG=/etc/gitlab-runner/config.toml

if grep -qs '^\[\[runners\]\]' "${CONFIG}"; then
  echo "a runner is already registered, nothing to do"
  exit 0
fi

api() { curl -fsS --max-time 30 -H "PRIVATE-TOKEN: ${BOOTSTRAP_TOKEN}" "$@"; }

echo "waiting for ${GITLAB_URL} (certificate issued, Rails up, token created)"
# One call proves all three: TLS works, GitLab answers, and the bootstrap token exists.
attempts=0
until api "${GITLAB_URL}/api/v4/user" >/dev/null 2>&1; do
  attempts=$((attempts + 1))
  if [ "${attempts}" -gt 360 ]; then
    echo "GitLab did not become ready within 90 minutes" >&2
    exit 1
  fi
  sleep 15
done

echo "creating the instance runner"
response=$(api -X POST "${GITLAB_URL}/api/v4/user/runners" \
  --data-urlencode "runner_type=instance_type" \
  --data-urlencode "description=${RUNNER_NAME}" \
  --data-urlencode "tag_list=${RUNNER_TAGS}" \
  --data-urlencode "run_untagged=true")
runner_token=$(jq -er '.token' <<<"${response}")

echo "registering"
# Tags and run_untagged were set at creation; with an authentication token (glrt-...)
# they can no longer be passed to "register".
gitlab-runner register --non-interactive \
  --url "${GITLAB_URL}" \
  --token "${runner_token}" \
  --name "${RUNNER_NAME}" \
  --executor docker \
  --docker-image alpine:3.22 \
  --docker-pull-policy if-not-present \
  --docker-privileged \
  --docker-volumes /certs/client \
  --docker-volumes /cache

sed -i "s/^concurrent = .*/concurrent = ${RUNNER_CONCURRENT}/" "${CONFIG}"
systemctl restart gitlab-runner

echo "revoking the bootstrap token"
api -X DELETE "${GITLAB_URL}/api/v4/personal_access_tokens/self" >/dev/null \
  || echo "WARNING: could not revoke the bootstrap token; it expires on its own within 2 days" >&2

echo "runner registered"
