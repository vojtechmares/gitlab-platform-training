#!/usr/bin/env bash
# Reference solution. usage: lost-work.sh DIR
# shellcheck source=../lib.sh
source "$(dirname "$0")/../lib.sh"
cd "$1" || exit 1
[ "$(git rev-list --count HEAD)" = "3" ]
# 1. the hard reset: the old tip is one step back in the reflog of HEAD
git reset -q --hard "HEAD@{1}"
[ "$(git rev-list --count HEAD)" = "6" ]
# 2. the deleted branch: find its last commit in the reflog and name it again
tip="$(git reflog --all | grep 'Report: conclusion' | head -1 | cut -d' ' -f1)"
[ -n "${tip}" ]
git branch feature/report "${tip}"
[ "$(git rev-list --count main..feature/report)" = "2" ]
echo "lost-work: main has 6 commits again and feature/report is back"
