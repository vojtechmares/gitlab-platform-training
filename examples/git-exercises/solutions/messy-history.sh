#!/usr/bin/env bash
# Reference solution. usage: messy-history.sh DIR
# shellcheck source=../lib.sh
source "$(dirname "$0")/../lib.sh"
cd "$1" || exit 1
before="$(git rev-parse HEAD)"
[ "$(git rev-list --count main..HEAD)" = "7" ]
# Todo order is: 1 wip, 2 add login, 3 fix, 4 oops forgot the form, 5 wip2 validation, 6 fix again, 7 typo.
# Wanted: one commit for the login logic, one for the form, one for the README, in that order.
editor="$(mktemp)"
cat >"${editor}" <<'S'
#!/usr/bin/env bash
awk '{ line[NR] = $0 } END {
  n = split(line[1], a, " "); sub(/^pick /, "", line[1])
  print "pick "  substr(line[1], 1)
  for (i = 2; i <= 3; i++) { sub(/^pick /, "", line[i]); print "fixup " line[i] }
  for (i = 5; i <= 6; i++) { sub(/^pick /, "", line[i]); print "fixup " line[i] }
  sub(/^pick /, "", line[4]); print "pick " line[4]
  sub(/^pick /, "", line[7]); print "pick " line[7]
}' "$1" >"$1.new" && mv "$1.new" "$1"
S
chmod +x "${editor}"
GIT_SEQUENCE_EDITOR="${editor}" git rebase -q -i main
rm -f "${editor}"
[ "$(git rev-list --count main..HEAD)" = "3" ]
[ -z "$(git diff "${before}" HEAD)" ]   # the final content is identical
echo "messy-history: 3 clean commits, identical content"
