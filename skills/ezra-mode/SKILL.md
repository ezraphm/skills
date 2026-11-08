---
name: ezra-mode
description: >-
  Use when scoring how a bot (or an agent run) does its job, when a bot claims DONE/PASS, or before an agent declares its own work done. The 7-criterion rubric on a 0 to 4 scale with a required evidence cell per score, the hard DONE definition (reproducible command plus raw output pasted verbatim), the evidence-class labels PRIMARY/SECONDARY/BLOCKED, the one-bot-per-period spot-check record line, and the mandatory report line `Skill: ... / Evidence: ... / [to X]: ...`.
---

# ezra-mode, how work is scored here

Owner mandate 2026-11-03 set 5 criteria. The 2026-11-05 revision added criteria 6 and 7. A score
means something only if someone else can re-run the numbers behind it. This skill fixes the
yardstick so every reviewer asks the same 7 questions.

## When to apply

- Scoring a bot or an agent run over a period.
- Scoring your own run before reporting it done.
- Deciding whether another agent's "it passes" claim can be trusted.

Skip it for: code correctness review (that is a PASS/FAIL verdict on a diff, a different job), and
anything about cost or business numbers.

## The 7 criteria (0 to 4)

| # | Criterion | Question | How someone else checks it |
|---|---|---|---|
| 1 | One job | One measurable objective; does not take over another bot's work | Read the instructions, then match the report's work items to that role |
| 2 | One voice | One format and one style, stable across runs | Files of the same kind in `shared/`: same header, same section order |
| 3 | Anti-jobs explicit | The instructions list what it must NOT do | Compare the boundary lines with what the run actually did |
| 4 | No extra tools or rights | Minimum rights; anything with a wide blast radius goes to the owner | List the tools the run actually called |
| 5 | Verified | The result carries checkable evidence | Filled in by criteria 6 and 7 |
| 6 | Skill compliance | Loaded the skill its seat requires, and the output shows what the skill produced | Rerun a command the output cites; check for a command/output block, not a summary |
| 7 | Evidence discipline | Every done claim traces to a rerunnable command; uncheckable things stop at BLOCKED | Rerun one bot's command per period |

Scale: 0 = not present. 1 = claimed, nothing behind it. 2 = partly, with gaps. 3 = present and
checkable. 4 = present, checkable, and someone else reproduced it.

## The score table carries evidence or the number is void

Every row of a score table needs an evidence cell. The cell holds one of:

- a command anyone can rerun, and the number it prints, or
- a quote from the run's own output, with the file path it came from, or
- `no reproducer`, then the reason.

A number with no command and no quoted output gets `0`. A criterion nobody produced evidence for
at all is `BLOCKED`, not `0` (see Evidence classes).

The evidence cell says what the command proves and what it does not. "rev-parse HEAD matches" proves
the commit is the one claimed. It does not prove the content in that commit is correct.

## DONE is a hard rule

DONE needs all three:

1. A command anyone can rerun.
2. Its raw output pasted verbatim in the report. Re-typing the numbers from that output is a
   rewrite, not proof.
3. Another agent runs the command elsewhere and gets the same result.

Missing 1 or 2: write `CHUA CHUNG MINH`. A summary without output is not evidence.

You cannot run it because of rights or environment: write `BLOCKED: <reason>`. Never round that up
to done or nearly done.

`build passed`, `typecheck green`, and an `ok:true` from a write tool are not DONE by themselves. A
write that returns ok:true proves the call ran, not that the content landed. Read the written value
back first.

## Evidence classes

Label every evidence cell with where the evidence came from:

- `PRIMARY`: this agent ran the command in this period and shows the output.
- `SECONDARY`: another agent's report or claimed output. Usable, capped at scale 3, and the label
  says who produced it.
- `BLOCKED`: no evidence exists. This is not a low score; the cell says what could not be checked
  and why.

Silence is not a fail. No claim in the period means `BLOCKED`, never 0 for behaviour nobody saw.

## Spot-check procedure (one bot per period)

1. Pick one bot that claimed done, passing, or PASS this period.
2. Take the exact command that bot wrote, not the number it reported.
3. Run it outside the main repo (a separate clone or a tmp dir).
4. Record one line: `bot | command | matches / differs / could not run | PASS/FAIL`.
5. Do not fix the bot or edit its files. On FAIL, send the command and the output to the
   coordinator through the messaging tool.

## Mandatory report line

End the bot's section of the report with this line, values filled in:

`Skill: PASS/FAIL/BLOCKED with its name / Evidence: PASS/FAIL/BLOCKED / [to X]: co/khong co`

`[to X]` answers one question: did the work actually reach the other agent? Only a real send
counts. A line in a reply is not a send.

## Failure modes seen (keep as memory)

- Reporting a test count from an earlier run as this run's evidence.
- Reporting a version bump or a push as "the change is live". The client may cache by version and
  needs a reinstall before it sees anything.
- Writing "the other bot was assigned" when nothing was sent. The receiver got zero bytes. See
  `handoff-that-arrives`.
- Scoring a bot by reading its claims instead of rerunning one command.
- Scoring a rule the skill file does not contain, from memory, then quoting it as if it had been
  read.

## What this skill does not do

It does not collect the evidence, and it does not make the reviewer independent. The reviewer still
reads logs and reruns commands. The skill only fixes the questions so the same ones get asked each
time.
