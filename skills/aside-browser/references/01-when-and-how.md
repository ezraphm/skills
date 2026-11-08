# 01 — When to use Aside, and how to report it

## Choose the tool by what the job needs

| Need | Tool |
|---|---|
| A page the user is already signed into (Gmail, Slack, GitHub, a console, a bank) | Aside |
| What the user did before: sites visited, notes they saved, history | Aside (`aside` memory/history surface from `aside guide`) |
| A public page, one lookup, no interaction | `web_fetch` / `web_search` — cheaper, no browser window |
| A file already on disk, a local app, a terminal | file tools and shell, not a browser |
| A test of your own code that must not touch the user's session | headless runner, if the repo has one — not the user's browser |

Aside is the default for anything with a browser and a login. It is not the default for a page a plain fetch can read.

## Scope before you open anything

Answer these three before the first navigation, in one line each, for yourself:

- **Which site and which account?** Several accounts on the same site is the classic wrong-account mistake.
- **Read or write?** Reading a page is free. Writing (a post, an order, a form submit, a delete) is where approval boundaries apply — see `08-approval-boundaries.md`.
- **What proves it worked?** A URL, a visible element, a row count, a downloaded path. Decide before acting, so the proof is not invented afterwards.

If the site or account is ambiguous and picking wrong costs money, data, or touches another person's account, ask — one question, with your default. Do not guess an account.

## Read the guide first, every session

```bash
aside --version
aside guide            # session basics
aside guide repl       # before the first repl call
```

Do not infer command syntax from this skill or from memory. The guide is versioned with the CLI; this skill is not. If `aside guide` and this skill disagree about syntax, the guide wins. If they disagree about judgement, this skill wins.

## Report shape

Four fields, no prose padding:

- **What**: the site and the goal, one clause.
- **Evidence**: URL, element text, count, file path, screenshot — whatever the "what proves it worked" line said.
- **Blocked**: what stopped you, or `none`.
- **Approval needed**: the exact action waiting on the user, or `no`.

Never report "opened the page" as an accomplishment. The accomplishment is what the page now shows.

## What Aside is not for

- Not a scraper fleet. One page, one session, unless the user asked for a crawl.
- Not a place to park a long job on the user's screen. They may be using that screen; see `09-troubleshooting.md` for locking and interference.
- Not a credential store. Never type a password from chat into a page; see `03-signed-in-and-credentials.md`.
