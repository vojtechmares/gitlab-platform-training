#!/usr/bin/env bash
# Reference solution. usage: wrong-branch.sh DIR  (DIR contains work/ and origin.git)
# shellcheck source=../lib.sh
source "$(dirname "$0")/../lib.sh"
cd "$1/work" || exit 1
git branch feature/export        # the two commits get a name first
git reset -q --hard origin/main  # main goes back to what the server has
git switch -q feature/export
[ "$(git rev-parse main)" = "$(git rev-parse origin/main)" ]
[ "$(git rev-list --count main..feature/export)" = "2" ]
echo "wrong-branch: main == origin/main, feature/export is 2 commits ahead"
