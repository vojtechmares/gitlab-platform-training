#!/usr/bin/env bash
# Work that looks gone: a hard reset and a deleted branch. Practice: git reflog, git branch, git reset.
#   ./lost-work.sh [DIR]
# shellcheck source=lib.sh
source "$(dirname "$0")/lib.sh"
DIR="${1:-practice-lost-work}"
new_repo "${DIR}"

for n in 1 2 3; do
  echo "line ${n}" >>"${DIR}/notes.txt"
  commit_all "${DIR}" "Notes: line ${n}"
done
for n in 4 5 6; do
  echo "important line ${n}" >>"${DIR}/notes.txt"
  commit_all "${DIR}" "Important work: line ${n}"
done

git -C "${DIR}" switch -q -c feature/report
echo "report draft" >"${DIR}/report.txt"
commit_all "${DIR}" "Report: first draft"
echo "report conclusion" >>"${DIR}/report.txt"
commit_all "${DIR}" "Report: conclusion"
git -C "${DIR}" switch -q main

git -C "${DIR}" branch -D feature/report >/dev/null
git -C "${DIR}" reset -q --hard HEAD~3

say "Created ${DIR}. Two accidents happened:"
say "  1. someone ran 'git reset --hard HEAD~3' on main (three commits are missing from git log)"
say "  2. the branch feature/report was deleted with 'git branch -D'"
say "Goal: get all of it back."
