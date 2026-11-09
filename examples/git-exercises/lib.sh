#!/usr/bin/env bash
# Shared helpers for the practice scenarios. Sourced, not run.
set -euo pipefail

export GIT_CONFIG_NOSYSTEM=1

# guard_dir DIR MARKER - refuse to delete a folder that is not an earlier practice scenario.
# Running a script again rebuilds its folder from scratch; that must never destroy someone's own work.
guard_dir() {
  local dir="$1" marker="$2"
  if [ -e "${dir}" ] && [ ! -e "${dir}/${marker}" ] && [ -n "$(ls -A "${dir}" 2>/dev/null)" ]; then
    echo "'${dir}' already exists and is not a practice scenario, so it will not be deleted. Choose another folder name." >&2
    exit 1
  fi
}

# new_repo DIR  - empty repository on branch main with a local identity
new_repo() {
  guard_dir "$1" .git/practice-scenario
  rm -rf "$1"
  mkdir -p "$1"
  git -C "$1" init -q -b main
  touch "$1/.git/practice-scenario"
  git -C "$1" config user.name "${PRACTICE_NAME:-Practice User}"
  git -C "$1" config user.email "${PRACTICE_EMAIL:-practice@example.com}"
  git -C "$1" config commit.gpgsign false
  git -C "$1" config core.editor true # never open an editor by accident
  # Pin the settings that change how merge and pull behave, so the scenario works the same on every
  # machine whatever the user's global ~/.gitconfig says (see the "git config" part of the lab).
  git -C "$1" config merge.ff true
  git -C "$1" config pull.rebase false
  git -C "$1" config core.autocrlf false # no line-ending conversion: a CRLF in test.sh would break git bisect on Windows
}

# write_file DIR PATH  (content on stdin)
write_file() {
  mkdir -p "$(dirname "$1/$2")"
  cat >"$1/$2"
}

# commit_all DIR "message" [author name]  - stages everything and commits
commit_all() {
  local dir="$1" message="$2" author="${3:-}"
  git -C "$dir" add -A
  if [ -n "${author}" ]; then
    git -C "$dir" -c user.name="${author}" -c user.email="$(tr '[:upper:]' '[:lower:]' <<<"${author}")@example.com" commit -q -m "${message}"
  else
    git -C "$dir" commit -q -m "${message}"
  fi
}

say() { printf '%s\n' "$*"; }
