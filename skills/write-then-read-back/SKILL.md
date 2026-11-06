---
name: write-then-read-back
description: Use after ANY write - instructions, routine prompt, Linear issue or comment, config, file - before reporting done. A tool returning ok:true proves the call ran, not that the content is correct. Re-open the object in the same turn and quote the exact field.
---

# ok:true is not proof

## The rule (owner ruling 2026-11-05 17:49)
A tool returning `ok:true` proves the write happened. It does NOT prove the content is correct, complete, or attached to the object you meant. Never report "done" on a write until you have re-opened the object and read the actual field.

## Procedure
1. Perform the write.
2. In the SAME turn, re-open the object with a read call.
3. Quote the exact field, verbatim, in the report.
4. Only then write done.

## Read-back per object type
| You wrote | Re-open with | Quote back |
|---|---|---|
| Bot instructions | fleet listing with the bot id | grep the new rule yourself |
| Routine prompt | schedule_list | the `prompt` string, id, active, nextRunAt |
| Linear issue field | get_issue | `status`, `assignee`, `dueDate`, `projectMilestone` |
| Linear comment | list_comments | comment id, author, timestamp, body |
| Milestone | list_milestones | `progress` count |
| File | ls -l + md5sum + head | byte size, hash, first lines |
| Git ref | git ls-remote / rev-parse | the full hash and the branch it is on |

## Observed failures (real, not hypothetical)
- `schedule_update` on a routine prompt returned ok:true; the prompt string was never read back, so "the prompt is written" was unproven.
- `schedule_create` returned ok:true when the correct answer was "already exists" - two different outcomes, one indistinguishable signal.
- A brief claimed "dev is green 66/0" while a separate test file that `run.js` never requires was failing 2 DST cases. Reading back the actual runner wiring, not just its output, is the fix.

## If the owner says it is still wrong
Re-read the actual content FIRST. Never explain it away as "that is just how the rule is worded". Then fix, then read back again.

## Editing an instruction file
Rewrite it clean: no appended duplicate blocks, no leftover sections at the end. After saving, read the whole text back top to bottom and check for duplication.
