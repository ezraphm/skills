---
name: ezra-mode
description: Use when scoring how a bot (or an agent run) does its job, or before declaring its own work done. The 7-criterion rubric on a 0-4 scale, the hard DONE definition (reproducible command + raw output + another bot can re-run it), the 5-step spot-check procedure, and the mandatory per-bot report line. Turns a fixed rubric into something every bot can apply to itself, not only the reviewer.
---

# ezra-mode — how work is scored here

Owner mandate 2026-11-03 gives 5 criteria; the 2026-11-05 revision adds 2 checks (6 and 7) and does not replace the first 5.
A score is only worth something if the numbers behind it are reproducible. That is the whole point of this skill: the same 7 questions, asked by anyone.

## When to apply

- Scoring a bot's performance over a period (a review, a weekly pass).
- Scoring your own run before you report it done.
- Deciding whether another bot's "it passes" claim can be trusted.

Skip it for: review of code correctness (that is a PASS/FAIL verdict on a diff, a different job), and anything about costs or business numbers.

## The 7 criteria (scale 0-4)

| # | Criterion | Question to check | How a machine checks it |
|---|---|---|---|
| 1 | **One job** | Exactly one measurable objective; does not take over another bot's work | Read the instructions; line up the report's work items against the stated role |
| 2 | **One voice** | One style + one output format, stable across runs | Files of the same kind in `shared/`: same header, same section order |
| 3 | **Anti-jobs explicit** | A concrete list of what it must NOT do | Find the boundary line, then compare it with the behaviour actually recorded in the files |
| 4 | **No extra tools/rights** | Minimum rights; high blast radius goes through the owner | Grep the tools actually called in the log/tool output |
| 5 | **Verified** | The result carries checkable evidence | Criteria 6 and 7 are what make this concrete |
| 6 | **Skill compliance** (added 2026-11-05) | Loaded and followed the required skill for its seat (`/verification` for technical work, `/eval-playbook` when authoring a skill); the output carries **commands + output**, not only prose | Re-run the command the bot cites; check the output has a command/output block, not a summary |
| 7 | **Evidence discipline** (added 2026-11-05) | Every "done" claim traces to something someone else can re-run; where it cannot be checked it stops at `BLOCKED` instead of guessing | Use the spot-check procedure below — re-run one bot's command each period |

Scale: 0 = not present · 1 = claimed, nothing behind it · 2 = partly, with gaps · 3 = present and checkable · 4 = present, checkable, and reproduced by someone else.

## DONE is a hard rule

DONE needs all three:
- (a) a **command that can be reproduced**;
- (b) the **raw output pasted verbatim** (no re-typed numbers, no summary);
- (c) **another bot can run that command** and get the same thing.

Missing (a) + (b) -> write `CHUA CHUNG MINH` (not proven). A summary without output is not evidence.
Cannot check it because of missing rights or missing environment -> write `BLOCKED: <reason>`. Never let that become "done" or "nearly done".
"Build passed", "typecheck green", "ok:true from the tool" are **not** DONE on their own: a write returning ok:true proves the call ran, not that the content is right — read it back.

## Spot-check procedure (one bot per period)

1. Pick one bot that claimed "done / passing / PASS" this period.
2. Take the **exact command** the bot wrote in its own file — not the number it reported.
3. Run that command in your own environment (separate clone / tmp dir, never the main repo).
4. Record one line: `bot | command | matches number / differs / could not run | PASS/FAIL`.
5. Do not fix the bot, do not edit its files. On FAIL, report to the coordinator with the command and output.

## Mandatory report line

End each bot's section of the period report with exactly this line, filling in the real values:

`Skill: PASS/FAIL/BLOCKED - Evidence: PASS/FAIL/BLOCKED - [to X]: co/khong co`

`[to X]` means "was the work actually delivered to the other bot" — delivered means a real send call, not a line written in a reply.

## Failure modes seen (keep as memory)

- Reporting a test count from a previous run as this run's evidence. The number must come from this run's output.
- Writing "the other bot was assigned" when no send happened; the receiving bot got zero bytes. See `handoff-that-arrives`.
- Scoring a bot's claims by reading them instead of re-running one command.

## What this skill does not do

It does not collect the evidence for you, and it does not make you independent. The reviewer still has to spend the time reading logs across bots — the skill only fixes the yardstick so the same questions are asked every time.
