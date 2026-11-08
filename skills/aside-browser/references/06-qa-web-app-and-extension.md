# 06 — QA and smoke tests of a web app or extension page

This is the browser half of QA. For the build-reload gate on an extension — proving the tab is running the build you think it is — the deeper checklist lives in the `aside-live-qa` skill; read it when a PR verdict depends on runtime state.

## Smoke test: five things, in this order

1. **It loads.** The URL resolves and the app's shell renders. Blank page, spinner forever, or a console error is the finding — stop there.
2. **The main path works.** The one flow the feature exists for: submit the form, open the item, see the list.
3. **The state persists.** Reload the page and check the result is still there. Many "works" bugs are optimistic UI with a failed write behind them.
4. **The failure path is sane.** Empty input, a too-long value, a duplicate — does it explain itself or silently swallow?
5. **Nothing else broke.** One adjacent screen that shares the component.

## Rules that keep the verdict honest

- **Prove which build is live before measuring anything.** In an extension page, a stale content script in an open tab is indistinguishable from a buggy new build. If the old marker is present and the new global is undefined, you are measuring the old build, not the new code.
- **One variable per run.** Change the code, not the code and the account and the fixture.
- **Negative control** where the claim is "this metric distinguishes good from bad": measure the same metric on a state you know is wrong, so the metric is shown to be sensitive.
- **State the environment**: app version or commit, browser profile, OS, viewport, and whether a session existed. A verdict without those is not reproducible.
- **Three verdicts only**: PASS, FAIL, **not measurable** — with the specific reason (locked screen, stale build, no session, no server). "Not measurable" is a legitimate answer; an inferred PASS is not.

## Reporting to whoever asked for the verdict

A four-column table closes it: **check · status · numeric evidence · measured when**. Every PASS row carries a number, a path, or an element that exists. Every FAIL row carries the reproduction step.

Do not merge, tag, deploy, comment on a PR, or push based on a QA run unless explicitly asked. The QA seat produces evidence; the merge seat decides.

## Extension pages specifically

- Open the extension's own page from the browser's extension surface, not by typing a guessed `chrome-extension://` id — ids change per install.
- Check the service worker is awake: an asleep worker looks like a broken feature for a few seconds.
- `localStorage` and other globals are per-origin; a key written under one extension id is absent under another.
