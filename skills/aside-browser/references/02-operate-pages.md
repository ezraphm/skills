# 02 — Operating a page: navigate, click, fill

## The loop

1. **Navigate** to the URL, or attach to the tab the user already has open. Attach first when the user says "this page" or "the tab I have open".
2. **Snapshot** to get element refs (`e1`, `e2`, …). Refs are cheap and exact; coordinates are not.
3. **Act** on a ref: click, fill, type.
4. **Snapshot again** and read the diff. Never assume the click did what the label promised.

Refs go stale after a navigation, a modal, or a re-render. When an action returns "element not found", the answer is a fresh snapshot, not a retry with the same ref.

## Batch what cannot surprise you

Predictable sequences (fill three fields, tick a box, then submit) can be batched. Insert a snapshot before anything that could change the page: a submit, a navigating click, a dropdown that reveals new fields, anything that might open a dialog. One extra snapshot is cheaper than a wrong action on a stale ref.

## Fill versus type

- **Fill** replaces the field's value in one go. Use it for ordinary inputs, search boxes, and textareas.
- **Type** sends keystrokes, which is what autocomplete widgets and masked inputs watch for. Use it when fill leaves the field visually filled but the app's own state empty — the classic symptom is a submit button that stays disabled.
- **Dropdowns**: select by the option's visible label, not by index. Index changes with translation and ordering.

## Forms: the four-step proof

A form is done when the server says so, not when the button goes grey.

1. Snapshot, identify the fields and their current values. Note anything already filled by the app — do not overwrite it blind.
2. Fill. Re-snapshot to confirm the values landed in the right fields.
3. Submit as its own step, so its result is attributable.
4. Read the outcome: a success banner, a new URL, a row that now exists, a "we sent you an email" line. If the page looks unchanged, check for an inline error before concluding success — many forms fail silently above the fold.

## Navigation traps

- **Consent and cookie walls** cover the real page. Dismiss the narrow choice (necessary/essential) unless the user says otherwise; accepting everything on their behalf is a data decision, not a UI one.
- **Sign-in walls** are not a licence to create an account. Stop and ask; see `03`.
- **Redirects to a different domain** mean the session, the region, or the consent flow changed. Read the address before acting.
- **Infinite scroll**: scroll a fixed number of times and record the item count each time. "Loaded everything" needs a count that stopped growing.
- **New tabs and popups**: the page object you had is no longer the interesting one. Enumerate the tabs, attach to the new one, and confirm the URL before acting in it.

## When an action fails

Say what you saw, then change one thing:

- Same ref twice, still failing → snapshot; the ref moved.
- Element present but click does nothing → it may be covered by an overlay, or it may be a `<div>` with a handler that needs a real mouse event. Try the element's own click, then a coordinate click in the centre of the visible element.
- Field ignored → try type instead of fill, then read the value back.
- Page blank → do not loop. Go to `09-troubleshooting.md`.

Two identical failures is the limit. After that, report the blocker with the snapshot and stop: a third replay is a guess, and a guess on a write action is how the wrong thing gets submitted.
