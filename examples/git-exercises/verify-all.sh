#!/usr/bin/env bash
# Trainer check: build every scenario and run its reference solution. Takes a few seconds.
#   ./verify-all.sh
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "${WORK}"' EXIT
for name in history conflict wrong-branch lost-work messy-history bisect; do
  "${HERE}/${name}.sh" "${WORK}/${name}" >/dev/null
  "${HERE}/solutions/${name}.sh" "${WORK}/${name}"
done
# A scenario must refuse to delete a folder that is not one of its own (someone's work, or a typo like ".").
mkdir "${WORK}/precious" && echo "keep me" >"${WORK}/precious/notes.txt"
for name in history conflict wrong-branch lost-work messy-history bisect; do
  if "${HERE}/${name}.sh" "${WORK}/precious" >/dev/null 2>&1; then
    echo "FAIL: ${name}.sh overwrote a folder that is not a practice scenario" >&2
    exit 1
  fi
done
[ "$(cat "${WORK}/precious/notes.txt")" = "keep me" ] || { echo "FAIL: precious folder was changed" >&2; exit 1; }
# ... but it rebuilds its own folder when run again.
"${HERE}/conflict.sh" "${WORK}/conflict" >/dev/null
echo "all scenarios are solvable, and refuse to delete foreign folders"
