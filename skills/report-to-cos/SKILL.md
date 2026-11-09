---
name: report-to-cos
description: Use when reporting to the Chief of Staff (Rosie) in any space. Fixes the six-line report packet every bot must send - WHAT, EVIDENCE, CHANGED, BLOCKED, APPROVAL, NEXT - and the ban rules that make it checkable. Reports only; sending law lives in handoff-that-arrives, evidence bar in ezra-mode.
---

# Report to the CoS, six lines, nothing else

## Why this exists

Bots send prose. The CoS then re-reads N prose blobs to build one short owner digest, and cannot
tell a claim from a command. This skill fixes packet shape and report-delivery states. Assignment transport belongs to
handoff-that-arrives; evidence quality belongs to ezra-mode.

## The packet - one per stage, six labelled lines

Labels in caps, this order. A line may be `NONE`; no line may be dropped and no two lines merged -
the fixed shape is the whole point.

```
WHAT:      <one line: the thing that exists NOW that did not exist before - an object, not an activity>
EVIDENCE:  <one re-runnable command + the output line it prints, quoted verbatim, or path + md5.
            The quality bar for this line is ezra-mode's, not this file's. If nothing qualifies: UNPROVEN>
CHANGED:   <files / commits / branches touched, or NONE>
BLOCKED:   <what is stuck and on whom, or NONE>
APPROVAL:  <NO | YES: what needs deciding>
NEXT:      <one line: the single next stage and who owns it>
```

Validity rules:

- Capped at those six lines. Detail goes in a file; the packet carries that file's path (+ md5) on
  EVIDENCE. A packet that needs more space links a file - it does not grow.
- `UNPROVEN` is a legal, expected value. It costs nothing. Claiming more than you proved does.
- One packet per stage. A second packet in the same thread starts `STAGE 2 — ` on the WHAT line.
- Put the Linear code (PSW-xx) or the PR name on the WHAT line when one exists.

## Ban rules

1. No progress prose, no step narration, no apology, no "still working on it" line.
2. No re-listing another bot's report. Nothing new -> post exactly `NOOP`.
3. No "done", "fixed", "works", "verified" without a command and its raw output.
4. No invented number, timestamp, commit sha, or other bot's status. Do not report a deadline you
   assumed: if the assignment carried none, write `NONE`.
5. No claim of runtime verification from a byte-identical file copy. A file that did not change is
   proof the source did not change, never proof that anything ran.
6. No `[to X]` in prose to deliver anything - see References.
7. No sending the same packet to the owner as well. The CoS is the single report target; the owner
   reads one digest, not N packets.

## Where a bot reports - and where it must not

- Work that belongs to a project outcome -> that project's group chat, packet as above.
- Approvals, secrets, logins, money, merge to main, deploy, anything sent outside, anything with
  consequence -> the owner's 1:1 chat, never a group, and only once the CoS has put the decision to
  him. A group packet may carry `APPROVAL: YES: <what>`; the decision itself happens in 1:1.
- This is a routing policy, not something a skill can enforce: a skill cannot see which thread it is
  in, and cannot stop a bot typing a secret (secrets belong to the platform's masked credential
  flow). It is written here because bots need the rule in front of them; the authority is the owner.
- The CoS is the only bot that writes the owner-facing digest. No other bot sends a digest, a
  summary of several bots, or a status ping.
- Silence is a valid state: nothing new -> `NOOP` or nothing at all. An incident is never silent.

## Delivery state is separate from work state

- RESULT_WRITTEN: a local report exists; no platform delivery is proven.
- POSTED: a final report is published in the shared thread where the stage was invoked, or an
  actually exposed report-only transport returns a destination-linked receipt. This is valid
  platform delivery, NOT proof of coordinator activation. An unfinished reply draft is not POSTED.
  Record the message ID when available; otherwise label receipt ID unavailable.
- ACKNOWLEDGED: Rosie explicitly acknowledges the exact task/stage and report message or digest.
  Membership, a completed worker run and a successful send alone are not acknowledgements.

Before posting, persist an internal outbox artifact with task_id, stage_id, producer_run_id,
destination_bot_id, destination_thread_id, report_digest, idempotency_key, state,
report_message_id, transport_kind, transport_receipt, coordinator_ack_message_id.
Unknown IDs stay unavailable, never invented. If task identity is ambiguous, use a labelled
provisional local stage key; Rosie must link it to a real task before closing delivery.
Keep metadata in the evidence artifact, not extra packet lines.

A final in the invoked shared thread is valid even without a send-only tool. Do not use a
report-only handoff bounce: handoff transfers ownership and is reserved for a distinct next
stage. Never invent message_bot availability. If the required destination is elsewhere and no
permitted transport exists, keep RESULT_WRITTEN and post the precise blocker in this thread;
that blocker post does not deliver the original report to its destination.

Use task + stage + report digest as the idempotency key. After interruption, reconcile accessible
history before retrying; an uncertain post is not permission for a blind resend. Same key reuses
the existing post/receipt; changed content gets a new digest and explicitly supersedes the old
report. Missing ACK stays POSTED, ACK pending. Rosie reconciles pending records on her existing
coordination cadence. No new routine, automatic owner ping or invented activation is authorized.
If history/receipts are unavailable, record that gap rather than claiming a dropped message.
Work may be finished while delivery remains open.

A future report-only runtime channel must notify Rosie without transferring ownership, return
task/destination/message receipts, deduplicate retries and expose ACK state. This is a requirement,
not an implemented capability. Runtime changes require separate approval.

## Bot vs subagent

A bot is a lasting seat - own thread, memory, computer - and owns a stage; a subagent lives inside
one turn and owns nothing. A stage assigned to a bot is never "also run" as a subagent for the same
request, and a subagent's output is not evidence until the bot re-ran the command itself.

## Consumer contract (what the CoS needs from a packet)

Build the owner digest from packets alone, without opening any bot's thread: one line per bot, at
most 3 decisions, anything past its stated deadline flagged as slipping. A packet that cannot
produce those is sent back to the bot, not escalated to the owner.

## Acceptance checks (run before trusting a change to this skill)

A1. A real six-line packet with a re-runnable command passes; the same content as three paragraphs fails.
A2. A "done, tested" packet with no command is rejected with reason `UNPROVEN` (not "wrong", not "redo").
A3. A local draft is RESULT_WRITTEN; a final in the invoked thread is POSTED; a source-linked Rosie ACK makes it ACKNOWLEDGED. A typed routing label proves none of these.
A4. Nothing new -> `NOOP`; the digest shows no line for that bot.
A5. A 20-line report is accepted only with the 20 lines in a file and path + md5 on the packet.
A6. MISSING-DATA case: a bot assigned a stage with no deadline reports `BLOCKED: no deadline from <who>`; the packet stays valid and the CoS does not invent a deadline for it.

## References (do not restate these here)

- `handoff-that-arrives` - assignment transport law; distinct work still requires an exposed tool.
  Completed-stage reports follow the states above, never ownership-transfer bounces.
- `ezra-mode` - the hard DONE definition and the evidence classes behind the EVIDENCE line.
- `write-then-read-back` - after any write to another bot, re-open and quote the field before saying done.

## Out of scope

- The CoS's own owner-facing report format (governed by her instructions).
- Group membership or seat count - owner-set, a bot cannot police it.
