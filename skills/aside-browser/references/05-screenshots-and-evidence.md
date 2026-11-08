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

## Privacy

- Redact or crop before attaching: emails, names, tokens, order numbers, balances, other people's data.
- A screenshot of the user's own inbox is still a dump of their inbox. Crop to the item that matters.
- Never screenshot a page showing a password field with a value, a recovery code, or a payment card in full.

## Naming and attaching

- Files go in the working folder, named for the claim they support (`qa-checkout-before.png`), not `screenshot1.png`.
- Attach the file to the thread so the user can open it; a path alone makes them go find it.
- In the report, the screenshot is evidence, so say which claim it supports in the same line.
