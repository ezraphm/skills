#!/usr/bin/env bash
# Runs every ezra-mode case file into evals/artifacts/<case>/checks.txt
set -u
cd /home/rakazo/skills-plugin-work/ezraphm-skills
A=evals/artifacts
for c in e1 e2 e3 e4 e5 e6; do mkdir -p "$A/$c"; done
./evals/artifacts/run-checks.sh e1 "A summary without output is not evidence" > "$A/e1/checks.txt" 2>&1
./evals/artifacts/run-checks.sh e2 "A number with no command and no quoted output gets" > "$A/e2/checks.txt" 2>&1
./evals/artifacts/run-checks.sh e3 "capped at scale 3, and the label" "present, checkable, and someone else reproduced it" > "$A/e3/checks.txt" 2>&1
./evals/artifacts/run-checks.sh e4 "never 0 for behaviour nobody saw" > "$A/e4/checks.txt" 2>&1
./evals/artifacts/run-checks.sh e5 "Only a real send" "counts. A line in a reply is not a send." "[to X]: co/khong co" > "$A/e5/checks.txt" 2>&1
./evals/artifacts/run-checks.sh e6 "does not contain, from memory" > "$A/e6/checks.txt" 2>&1
ls -l "$A"/e*/checks.txt
