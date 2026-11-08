# 04 — Extracting data and downloading files

## Read the page in the page's own terms

Snapshot first: it gives you the accessible names and roles the app actually exposes, which is usually what a human reading the screen would use. Reach for `page.evaluate` only when the extract is structural — a table, a list of cards, a JSON blob the app embedded.

Inside `page.evaluate`:

- Return plain data (arrays of objects with primitive fields), never DOM nodes.
- Prefer visible stable text over positional selectors (`nth-child` breaks the day someone adds a banner).
- Cap the result (`slice(0, N)`) so one runaway list does not blow up the output.
- `console.log` the result; returning it is not how you read it back.

## Pagination

- Record the item count after each step. Progress is a growing number, not a feeling.
- Use the site's own next-page control when there is one. Changing a `?page=` query parameter is a guess about the API and skips server-side state.
- Stop when a page returns zero new items, or when the count stops matching what you appended. Report the total you actually collected and the total the site claims; when they differ, say so instead of rounding.

## Saving what you found

- Write extracted data to a file in your working folder, not into chat. Chat is for the summary and the path.
- If the result is a deliverable the user will open (a report, a table, a page), make it a file and attach it; do not paste a wall of rows.
- Pure parsing of an already-downloaded file does not need the browser at all: use shell and `python3` for CSV, XLSX, and PDF text.

## Downloads

- A download triggered by a click is saved to the browser's download location; the call result lists the path. Read that path rather than guessing a filename.
- If the download is still in progress, it is not ready. Confirm the file exists and has non-zero size, then move it somewhere stable before the user's clean-up removes it.
- PDFs open in the browser viewer are still downloads: the path is what you process.
- A login wall behind a "download" button is not a broken download. Check the page says "sign in to continue" before retrying.

## What not to extract

- Nothing behind a "you must accept" gate that the user did not ask you to cross.
- No bulk scrape of a site that forbids it in terms you were shown.
- No personal data of third parties beyond what the task needs. If a page is a list of other people's emails, the deliverable is the count and the shape, not the dump.
