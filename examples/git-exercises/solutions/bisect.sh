#!/usr/bin/env bash
# Reference solution. usage: bisect.sh DIR
# shellcheck source=../lib.sh
source "$(dirname "$0")/../lib.sh"
cd "$1" || exit 1
first="$(git rev-list --max-parents=0 HEAD)"
git bisect start HEAD "${first}"
git bisect run ./test.sh >/tmp/bisect.$$ 2>&1
culprit="$(git log -1 --pretty=%s refs/bisect/bad)"
git bisect reset >/dev/null 2>&1
rm -f /tmp/bisect.$$
[ "${culprit}" = "Tidy up the changelog and speed up add()" ]
echo "bisect: found '${culprit}'"
