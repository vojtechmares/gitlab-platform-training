#!/usr/bin/env bash
# Two commits were made on main by mistake and not pushed yet. Practice: git branch, git switch, git reset.
#   ./wrong-branch.sh [DIR]     (creates DIR/origin.git and a clone in DIR/work)
# shellcheck source=lib.sh
source "$(dirname "$0")/lib.sh"
DIR="${1:-practice-wrong-branch}"
guard_dir "${DIR}" .practice-scenario
rm -rf "${DIR}"
mkdir -p "${DIR}"
touch "${DIR}/.practice-scenario"
git init -q --bare -b main "${DIR}/origin.git"
git clone -q "${DIR}/origin.git" "${DIR}/work" 2>/dev/null
git -C "${DIR}/work" config user.name "Practice User"
git -C "${DIR}/work" config user.email practice@example.com
git -C "${DIR}/work" config commit.gpgsign false
git -C "${DIR}/work" config merge.ff true
git -C "${DIR}/work" config pull.rebase false
git -C "${DIR}/work" config core.autocrlf false

write_file "${DIR}/work" app.py <<'T'
def hello():
    return "hello"
T
commit_all "${DIR}/work" "Add hello()"
git -C "${DIR}/work" push -q -u origin main

write_file "${DIR}/work" export.py <<'T'
def export():
    return []
T
commit_all "${DIR}/work" "Start the export feature"
write_file "${DIR}/work" export.py <<'T'
def export():
    return ["header"]
T
commit_all "${DIR}/work" "Add a header to the export"

say "Created ${DIR}/work. main is 2 commits ahead of origin/main, and those commits belong on a feature branch."
say "Goal: main equals origin/main again, and the two commits live on feature/export."
