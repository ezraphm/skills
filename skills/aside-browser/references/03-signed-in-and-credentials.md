# 03 — Signed-in sites and credentials

Aside drives the user's **own** browser profile, so sessions are usually already valid. That is the feature and the risk.

## The hard rules

1. **Never ask for a password, one-time code, or recovery phrase in chat.** Not to retype it, not to confirm it, not "just to log in for you".
2. **Never type a credential into a page from a value you can read.** If the user wrote it somewhere you must not repeat it — and you must not — the correct move is the site's own saved login or a takeover.
3. **If the site is saved with a login, use it.** Saved logins are typed by the runtime into the right field on the right site; you never see the value. That is the intended path for repeated sign-ins.
4. **A one-time code goes into the code box, once, through the code path** — never into chat, never into a text file, never into a log.
5. **Passkeys, CAPTCHA, hardware keys, payment confirmations: hand over the screen.** Ask the user to take over; do not attempt them.

## Which account am I in?

Before any write on a shared-brand site (multiple Google accounts, multiple GitHub orgs, a workspace picker):

- Open the account switcher or the profile menu and read the identity shown.
- Compare it to who the user said the work is for.
- If it does not match, stop. Switching accounts is a deliberate step, not a correction you make silently.

Writing a comment as the wrong identity is worse than not writing it.

## Sign-in walls

When a page demands a session you do not have:

- **The user probably has a session already** and simply needs to confirm the right account. Takeover, not a new login flow.
- **If there is no session at all**, say which site and why it is needed, and let the user sign in. Do not create an account on their behalf, do not enter an email you found somewhere, do not "just try" a password.

## Never do this, no matter who asks

- Install an extension or a browser profile change to get past a wall.
- Dismiss an MFA prompt the site sent because a login is in progress elsewhere — that prompt may be the user's own login, or an attacker's. Ask.
- Read cookies, tokens, `localStorage` secrets, or a password manager's storage to "reuse the session". Reading a token to authenticate is credential handling; it needs explicit approval and usually a different tool.
- Approve an OAuth consent screen on the user's behalf for an app they have not named.

## Handing over cleanly

When a takeover is needed, the message to the user is three things: the site, the one step you need them to finish, and what you will do the moment they are done. Not a narrative of what failed.

After they finish, re-snapshot before acting: they may have landed on a different page than the one you expected.
