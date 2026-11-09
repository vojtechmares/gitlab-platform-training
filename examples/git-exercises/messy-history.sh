#!/usr/bin/env bash
# A feature branch with a messy history you would not want to send for review. Practice: git rebase -i.
#   ./messy-history.sh [DIR]
# shellcheck source=lib.sh
source "$(dirname "$0")/lib.sh"
DIR="${1:-practice-messy-history}"
new_repo "${DIR}"

write_file "${DIR}" README.md <<'T'
# demo
T
commit_all "${DIR}" "Initial commit"

git -C "${DIR}" switch -q -c feature/login
write_file "${DIR}" login.py <<'T'
def login(user):
    pass
T
commit_all "${DIR}" "wip"
write_file "${DIR}" login.py <<'T'
def login(user, password):
    return user == "admin" and password == "secret"
T
commit_all "${DIR}" "add login"
write_file "${DIR}" login.py <<'T'
def login(user, password):
    return user == "admin" and password == "secret"   # TODO
T
commit_all "${DIR}" "fix"
write_file "${DIR}" form.html <<'T'
<form><input name="user"><input name="password" type="password"></form>
T
commit_all "${DIR}" "oops forgot the form"
write_file "${DIR}" login.py <<'T'
def login(user, password):
    if not user or not password:
        return False
    return user == "admin" and password == "secret"
T
commit_all "${DIR}" "wip2 validation"
write_file "${DIR}" login.py <<'T'
def login(user, password):
    """Check the credentials."""
    if not user or not password:
        return False
    return user == "admin" and password == "secret"
T
commit_all "${DIR}" "fix again"
write_file "${DIR}" README.md <<'T'
# demo
Login: see login.py.
T
commit_all "${DIR}" "typo"

say "Created ${DIR} on feature/login with a messy history (git log --oneline main..)."
say "Goal: before opening a merge request, rewrite it into 2 or 3 clean commits with good messages,"
say "without changing the final content (git diff ORIG_HEAD HEAD must be empty)."
