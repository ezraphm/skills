#!/usr/bin/env bash
# Deterministic checks for one ezra-mode eval case.
# Usage: run-checks.sh <case-id> <anchor1> [anchor2 ...]
# Writes the raw log to stdout (redirect it) and never touches other files.
# Env: REPO (repo working tree), DRAFT (v1.3.0 draft), BASE_GIT (v1.2.0 commit)
set -u
CASE="$1"; shift
REPO="${REPO:-/home/rakazo/skills-plugin-work/ezraphm-skills}"
DRAFT="${DRAFT:-/home/rakazo/shared/specs/ezra-mode-v1.3.0-draft.md}"
BASE_GIT="${BASE_GIT:-1b4c220}"

echo "# case $CASE - deterministic checks"
echo "# repo    $REPO"
echo "# draft   $DRAFT"
echo "# v1.2.0  git $BASE_GIT:skills/ezra-mode/SKILL.md"
echo

echo "## D0 repo state"
echo '$ git rev-parse --short HEAD'
git -C "$REPO" rev-parse --short HEAD
echo '$ git branch --show-current'
git -C "$REPO" branch --show-current
echo '$ grep -c "^| [0-9] |" <draft>   # criterion rows, must be 7'
grep -c "^| [0-9] |" "$DRAFT"
echo '$ sha256sum <draft>'
sha256sum "$DRAFT" | cut -d' ' -f1
echo

echo "## D1 anchor greps (grep -nF, raw output, exit code printed)"
for a in "$@"; do
  echo "\$ grep -nF -- '$a' <draft v1.3.0>"
  grep -nF -- "$a" "$DRAFT"; echo "[exit $?]"
  echo "\$ git show $BASE_GIT:skills/ezra-mode/SKILL.md | grep -nF -- '$a'"
  git -C "$REPO" show "$BASE_GIT:skills/ezra-mode/SKILL.md" | grep -nF -- "$a"; echo "[exit $?]"
done
echo

echo "## D2 anchor length (must be <= 40 chars, one physical line)"
for a in "$@"; do
  printf '%s -> %s chars\n' "$a" "${#a}"
done
