#!/usr/bin/env bash
# A bug crept in somewhere in 16 commits. Practice: git bisect (and git bisect run).
#   ./bisect.sh [DIR]
# shellcheck source=lib.sh
source "$(dirname "$0")/lib.sh"
DIR="${1:-practice-bisect}"
new_repo "${DIR}"

write_file "${DIR}" calc.sh <<'T'
#!/usr/bin/env bash
add() { echo $(( $1 + $2 )); }
add "$1" "$2"
T
chmod +x "${DIR}/calc.sh"
write_file "${DIR}" test.sh <<'T'
#!/usr/bin/env bash
# exit 0 = good, exit 1 = bad
[ "$(./calc.sh 2 3)" = "5" ]
T
chmod +x "${DIR}/test.sh"
commit_all "${DIR}" "Add calc.sh and its test"

for n in $(seq 2 16); do
  echo "release ${n}" >"${DIR}/CHANGELOG.md"
  if [ "${n}" -eq 9 ]; then
    write_file "${DIR}" calc.sh <<'T'
#!/usr/bin/env bash
add() { echo $(( $1 + $2 + 1 )); }
add "$1" "$2"
T
    chmod +x "${DIR}/calc.sh"
    commit_all "${DIR}" "Tidy up the changelog and speed up add()"
  else
    commit_all "${DIR}" "Release ${n}: update the changelog"
  fi
done

say "Created ${DIR}: 16 commits. ./test.sh passes on the first commit and fails on the last."
say "Goal: find the commit that broke it with git bisect, without checking each commit by hand."
