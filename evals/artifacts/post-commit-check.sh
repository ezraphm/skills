#!/usr/bin/env bash
# Post-commit check: the committed skill is the draft, and every case anchor is
# grep-able in the committed tree. Writes evals/artifacts/post-commit/checks.txt
set -u
cd /home/rakazo/skills-plugin-work/ezraphm-skills
OUT=evals/artifacts/post-commit/checks.txt
mkdir -p evals/artifacts/post-commit
{
echo "# post-commit check $(date -Iseconds)"
echo '$ git rev-parse --short HEAD'
git rev-parse --short HEAD
echo '$ git status --short'
git status --short
echo '$ sha256sum skills/ezra-mode/SKILL.md /home/rakazo/shared/specs/ezra-mode-v1.3.0-draft.md'
sha256sum skills/ezra-mode/SKILL.md /home/rakazo/shared/specs/ezra-mode-v1.3.0-draft.md
echo '$ grep -c "^| [0-9] |" skills/ezra-mode/SKILL.md'
grep -c "^| [0-9] |" skills/ezra-mode/SKILL.md
for a in "A summary without output is not evidence" "A number with no command and no quoted output" "capped at scale 3, and the label" "present, checkable, and someone else" "never 0 for behaviour nobody saw" "Only a real send" "counts. A line in a reply is not a send." "[to X]: co/khong co" "does not contain, from memory"; do
  echo "\$ grep -nF -- '$a' skills/ezra-mode/SKILL.md"
  grep -nF -- "$a" skills/ezra-mode/SKILL.md
  echo "[exit $?]"
done
echo '$ grep -nF -- "Only a real send counts. A line in a reply is not a send." skills/ezra-mode/SKILL.md'
grep -nF -- "Only a real send counts. A line in a reply is not a send." skills/ezra-mode/SKILL.md
echo "[exit $?]"
} > "$OUT" 2>&1
cat "$OUT"
