#!/usr/bin/env bash
# Check every example pipeline against GitLab's CI JSON schema (no GitLab instance needed).
#
#   scripts/check-ci-examples.sh
#
# Needs: python3 with the venv module, curl. Installs check-jsonschema into a temporary virtual environment.
# Settings (environment): SCHEMA_REF (default 19-5-stable-ee), SCHEMA_FILE (use a local ci.json instead of downloading).
#
# The schema cannot read GitLab's custom YAML tag "!reference [job, key]", so it is replaced by a plain string
# in a temporary copy before checking. The schema checks structure only; "CI Lint" on a live instance
# (scripts/smoke-test.sh) also resolves includes and templates.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CI_DIR="${HERE}/../examples/ci"
SCHEMA_REF="${SCHEMA_REF:-19-5-stable-ee}"
WORK="$(mktemp -d)"
trap 'rm -rf "${WORK}"' EXIT

if [ -n "${SCHEMA_FILE:-}" ]; then
  schema="${SCHEMA_FILE}"
else
  schema="${WORK}/ci.json"
  curl -sS -f -L -o "${schema}" \
    "https://gitlab.com/gitlab-org/gitlab/-/raw/${SCHEMA_REF}/app/assets/javascripts/editor/schema/ci.json"
fi

python3 -m venv "${WORK}/venv"
"${WORK}/venv/bin/pip" install -q check-jsonschema >/dev/null 2>&1

failed=0
while IFS= read -r file; do
  rel="${file#"${CI_DIR}"/}"
  copy="${WORK}/$(echo "${rel}" | tr '/' '_')"
  sed -E 's/!reference \[[^]]*\]/"reference-placeholder"/g' "${file}" >"${copy}"
  if out="$("${WORK}/venv/bin/check-jsonschema" --schemafile "${schema}" "${copy}" 2>&1)"; then
    printf 'ok    %s\n' "${rel}"
  else
    printf 'FAIL  %s\n%s\n' "${rel}" "${out}" >&2
    failed=1
  fi
done < <(find "${CI_DIR}" -name '*.yml' -not -path '*/components/*' | sort)

# examples/ci/components/ is not checked here: component files start with a "spec" document and a "---" separator,
# which the CI schema does not describe. That library has its own yamllint configuration (components/.yamllint).
exit "${failed}"
