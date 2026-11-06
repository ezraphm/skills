---
name: handoff-that-arrives
description: Use when assigning work to another bot. Blocks writing "[to X]" inside the chat reply - only message_bot / handoff_to_bot actually delivers. Includes the proof-of-send rules and the write-then-read-back verification rule.
---

# A handoff must arrive, not be written down nicely

## The root rule (owner ruling 2026-11-04 20:45)
Writing `[to Hogan]`, `[to Ward]`, `[to Kane]`, `[to anyone]` at the start of a block inside the REPLY TO THE OWNER means NOTHING IS SENT. The other bot receives zero bytes. The owner sees "assigned" while in reality nobody picked up the work.

Absolutely forbidden.

## Before writing any block that names another bot
1. Ask yourself: "Which tool will carry this?"
2. If the answer is not `message_bot` or `handoff_to_bot` -> STOP. Do not write it.
3. To assign work -> call `message_bot` IN THAT SAME TURN. The handoff body is a tool argument, never chat prose.
4. Never write "I will message", "I sent", "just sent" unless a tool result ok:true exists in this turn.

## Shape of a correct handoff
measurable objective - in scope / out of scope - sources - expected output - completion evidence - deadline - what needs approval.
Send it with `message_bot(bot_id, message)`. For a group: `handoff_to_bot(group_id, bot_id, message)`.

## Proof of sending: only three things count
- A tool result returned in this turn (ok:true + bot_id).
- A reply the other bot sends back (the system's `[from X]` block).
- A file path written plus `ls -l` in this turn.

Not proof: your own prose, "sent at 20:10" typed by yourself, or a plan to send.

## ok:true proves the command ran, never that the content is right
After every write - instructions, routine prompt, issue field, comment, file - re-open the object IN THE SAME TURN and quote the exact field before reporting done:
- routine prompt -> `schedule_list`, read back the `prompt` string.
- Linear issue -> `get_issue`, read back `status`, `assignee`, `dueDate`, `projectMilestone`.
- comment -> `list_comments`, quote the comment id and timestamp.
- file -> `ls -l` plus `md5sum`/`head` of the real content.

Observed failure: `schedule_update` returned ok:true on a routine prompt while the content was never read back; `schedule_create` returned ok:true when the correct answer was "already exists". Treat ok:true alone as unproven.

## When reporting to the owner
Write only: "sent to X - message_bot returned ok:true, <time>". With no ok:true this turn -> write NOT SENT.

## Self-check before ending the turn
- Does every bot named with work to do have one successful message_bot/handoff_to_bot call this turn?
- If not, did I state NOT SENT?
- Is there any `[to ...]` block sitting in the reply to the owner? -> delete it or turn it into a tool call.

## Failures that happened (kept as memory)
- 2026-11-04 18:35 -> 20:10: eleven `[to Hogan]` lines written as chat prose -> Hogan received nothing, went silent for 1h35, was mistakenly read as abandoning the work.
- Repeated twice more the same day despite being warned. This is a system failure, not a memory failure - which is why the skill exists.
