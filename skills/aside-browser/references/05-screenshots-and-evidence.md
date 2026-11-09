# 05 — Screenshots and visual evidence

## A screenshot proves what was on screen, nothing more

It is the right evidence for: layout, a rendered UI state, a visual regression, a watermark or overlay that breaks a flow, "the button is there but disabled".

It is the wrong evidence for: whether a value is stored, whether a request succeeded, whether a script ran. For those, read state or the network result.

## How to take one worth keeping

- **Viewport, not full page, when judging layout.** A full-page shot of a responsive app hides the fold.
- **Full page when the point is completeness** — a long list, a whole document, a form with everything visible.
- **Look at it before reporting it.** Display it and check it is not blank, not a loading spinner, not the wrong tab, not a cookie banner.
- **Set the viewport deliberately** when the question is mobile versus desktop behaviour; the same page renders differently and the claim depends on which you looked at.
- **Clip to the element** when the claim is about one component. A screenshot of a whole page to show one badge makes the reader find the badge.

## Before and after

Visual work needs a pair, captured at the same viewport with the same crop, and described in one line each: what changed and why that is the intended change. One "after" shot is not evidence of a fix; it is evidence of a state.

## Evidence table for claim-level work

When the job is "is this still true?" rather than "what does this page say?", a screenshot alone is not enough: the page can be alive while its claim has changed. Keep one row per claim with five fixed columns.

| Column | What goes in it |
|---|---|
| Claim | The sentence or number the deliverable depends on, quoted, not paraphrased |
| Source URL | The exact page a reviewer can reopen |
| Date accessed | The date you checked it, absolute |
| Artifact | Screenshot, downloaded file, or extracted text — the thing that shows the state |
| Status | `verified`, `changed`, `missing`, or `needs review` |

Three rules for the table:

- **Page alive, claim changed means status `changed`.** Record the old line and the current line side by side. Never mark it `verified` because the URL still returns 200.
- **Gone is a status, not a silence.** A 404, a redirect to a gated form, or a section removed from the page is `missing`, written down with what used to be there.
- **`needs review` is a legitimate final status.** Low-confidence extraction, a paywalled body, or a claim only a human can judge stays visible as `needs review`; do not promote it to `verified` to close the row.

The researcher, not the bot, decides what counts as evidence. Surface rows and statuses; do not silently drop an inconvenient one.

## Never use a raw response hash as a change fingerprint

An md5 of the raw response body is not proof that a page changed. Modern pages embed an SSR hydration timestamp, a nonce, or a cache buster, so the same unchanged page returns a different hash on every load.

- Compare **extracted text**, or a screenshot, or the specific claim — not the raw body hash.
- If you must record a hash, record the hash of the extracted text and label it as such.
- Two runs disagreeing on a raw hash, with identical extracted text, means **the page did not change**. Report "unchanged" and say the raw hash is volatile.

## Privacy

- Redact or crop before attaching: emails, names, tokens, order numbers, balances, other people's data.
- A screenshot of the user's own inbox is still a dump of their inbox. Crop to the item that matters.
- Never screenshot a page showing a password field with a value, a recovery code, or a payment card in full.

## Naming and attaching

- Files go in the working folder, named for the claim they support (`qa-checkout-before.png`), not `screenshot1.png`.
- Attach the file to the thread so the user can open it; a path alone makes them go find it.
- In the report, the screenshot is evidence, so say which claim it supports in the same line.
