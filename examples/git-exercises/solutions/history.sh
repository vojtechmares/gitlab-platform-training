#!/usr/bin/env bash
# Reference checks for the history scenario. usage: history.sh DIR
# shellcheck source=../lib.sh
source "$(dirname "$0")/../lib.sh"
cd "$1" || exit 1
[ "$(git rev-list --count main)" = "8" ]
[ "$(git log -S'prices[:-1]' --oneline | wc -l | tr -d ' ')" = "2" ]   # introduced and removed
git blame -L1,2 cart.py >/dev/null
[ "$(git tag)" = "v1.0" ]
[ "$(git rev-list --count main..feature/export)" = "2" ]
echo "history: 8 commits, tag v1.0, log -S finds the bug's two commits, feature/export is unmerged"
