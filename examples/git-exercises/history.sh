#!/usr/bin/env bash
# A repository with history worth reading: two authors, a tag, a bug that was introduced and fixed,
# and an unmerged feature branch. Practice: git log, show, diff, blame, log -S, tag.
#   ./history.sh [DIR]
# shellcheck source=lib.sh
source "$(dirname "$0")/lib.sh"
DIR="${1:-practice-history}"
new_repo "${DIR}"

write_file "${DIR}" README.md <<'T'
# demo
A tiny shopping cart.
T
commit_all "${DIR}" "Initial commit" Alice

write_file "${DIR}" cart.py <<'T'
def total(prices):
    return sum(prices)
T
commit_all "${DIR}" "Add total() for the cart" Alice

write_file "${DIR}" test_cart.py <<'T'
from cart import total

def test_total():
    assert total([1, 2, 3]) == 6
T
commit_all "${DIR}" "Add a test for total()" Alice

sed -i.bak 's/tiny shopping cart/tiny shopping cart library/' "${DIR}/README.md" && rm "${DIR}/README.md.bak"
commit_all "${DIR}" "Clarify the README" Bob

write_file "${DIR}" cart.py <<'T'
DISCOUNT = 0.1

def total(prices):
    return sum(prices)

def discounted(prices):
    return total(prices) * (1 - DISCOUNT)
T
commit_all "${DIR}" "Add discounted() with a 10 percent discount" Alice
git -C "${DIR}" tag -a v1.0 -m "First release"

write_file "${DIR}" cart.py <<'T'
DISCOUNT = 0.1

def total(prices):
    return sum(prices[:-1])

def discounted(prices):
    return total(prices) * (1 - DISCOUNT)
T
commit_all "${DIR}" "Speed up total() by skipping the last item" Bob

write_file "${DIR}" cart.py <<'T'
import logging

DISCOUNT = 0.1

def total(prices):
    return sum(prices[:-1])

def discounted(prices):
    logging.info("discounting %d prices", len(prices))
    return total(prices) * (1 - DISCOUNT)
T
commit_all "${DIR}" "Add logging to discounted()" Alice

write_file "${DIR}" cart.py <<'T'
import logging

DISCOUNT = 0.1

def total(prices):
    return sum(prices)

def discounted(prices):
    logging.info("discounting %d prices", len(prices))
    return total(prices) * (1 - DISCOUNT)
T
commit_all "${DIR}" "Fix total(): it dropped the last item" Alice

git -C "${DIR}" switch -q -c feature/export
write_file "${DIR}" export.py <<'T'
import csv

def to_csv(rows, path):
    with open(path, "w", newline="") as handle:
        csv.writer(handle).writerows(rows)
T
commit_all "${DIR}" "Start the CSV export" Bob
write_file "${DIR}" export.py <<'T'
import csv

def to_csv(rows, path):
    with open(path, "w", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow(["item", "price"])
        writer.writerows(rows)
T
commit_all "${DIR}" "Write a header row in the CSV export" Bob
git -C "${DIR}" switch -q main

say "Created ${DIR}: 8 commits on main, a tag v1.0, and an unmerged branch feature/export."
