#!/usr/bin/env bash
# Two branches change the same line. Practice: git merge, reading conflict markers, resolving, merge --abort.
#   ./conflict.sh [DIR]
# shellcheck source=lib.sh
source "$(dirname "$0")/lib.sh"
DIR="${1:-practice-conflict}"
new_repo "${DIR}"

write_file "${DIR}" config.yaml <<'T'
app:
  name: demo
  replicas: 2
  log_level: info
T
commit_all "${DIR}" "Add the app config"

git -C "${DIR}" switch -q -c feature/scale
write_file "${DIR}" config.yaml <<'T'
app:
  name: demo
  replicas: 4
  log_level: info
  region: eu
T
commit_all "${DIR}" "Scale to 4 replicas and pin the region"

git -C "${DIR}" switch -q main
write_file "${DIR}" config.yaml <<'T'
app:
  name: demo
  replicas: 3
  log_level: debug
T
commit_all "${DIR}" "Use 3 replicas and debug logging"

say "Created ${DIR}. You are on main. Both branches changed the replicas line."
say "Try: git merge feature/scale"
