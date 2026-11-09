#!/usr/bin/env bash
# Reference solution (trainer only). usage: conflict.sh DIR
# shellcheck source=../lib.sh
source "$(dirname "$0")/../lib.sh"
DIR="$1"
cd "${DIR}" || exit 1
git merge feature/scale >/dev/null 2>&1 && { echo "expected a conflict"; exit 1; } || true
grep -q '^<<<<<<<' config.yaml
cat >config.yaml <<'T'
app:
  name: demo
  replicas: 4
  log_level: debug
  region: eu
T
git add config.yaml
git commit -q -m "Merge feature/scale: 4 replicas, debug logging, region eu"
test -z "$(git status --porcelain)"
[ "$(git log -1 --pretty=%p | wc -w | tr -d ' ')" = "2" ]
echo "conflict: resolved, merge commit has two parents"
