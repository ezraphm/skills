# 09 — Troubleshooting

Diagnose before retrying. Every row here is "stop doing the failing thing and find out which layer is broken".

## The CLI

| Symptom | Move |
|---|---|
| `aside: command not found` | Ask before installing. Then run the installer from the skill body, then `aside guide`. |
| `aside guide` is an unknown command | The CLI is old. `aside --update`, then `aside guide`. |
| The guide reports a newer CLI | `aside --update`, then `aside guide` again before continuing. |
| A command works but the syntax differs from this skill | The guide is authoritative. Re-read it for that command. |
| Install or update fails | Report the error verbatim. Do not hand-assemble CLI usage from memory. |

## The browser

| Symptom | Move |
|---|---|
| "The user's screen is locked" | Nothing can be measured. Record *not measured*, with that reason. Never infer what the page would have shown. |
| The page is blank or a bare shell | Snapshot again once (a render may still be in flight). If still blank, check the URL, then reload. If still blank, report with the URL — do not keep clicking. |
| The site shows a wall or a redirect loop | Likely session or consent. Go to `03`; do not loop the navigation. |
| The browser or remote-desktop process looks dead | Do not kill, restart, or delete it. Report it as unavailable and continue with what does not need it. |
| Another actor may have moved the page | Re-observe before acting. The screen is shared; the snapshot you have may be older than the moment. |
| Element not found after a click | The page re-rendered. Fresh snapshot, new refs. |
| Same action fails twice | Stop. Report the snapshot and the two attempts. A third is a guess. |

## Judgement failures that look like tool failures

- **Claiming "it does not exist" because grep found nothing.** Absence of evidence in one place is not absence. Widen the search before asserting, and say what you searched.
- **Treating a stale build as current code.** Symptom and correct diagnosis live in `06` and, for extensions, in `aside-live-qa`.
- **Reporting success from a call result alone.** Read the effect.
- **Explaining a failure with a rule instead of reading the page.** If the user says it is still wrong, look again first.

## Escalation

Three lines to the user when escalating: what is broken (layer: CLI, browser, session, page), what you already proved, and the one thing you need. Offer a default so a silent user still gets progress.
