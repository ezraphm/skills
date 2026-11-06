# estack — agent operating rules

Rules for any agent reading, adding, or editing skills in this repo.

## What this repo is

A personal skill stack. The unit is `skills/<name>/SKILL.md`: plain Markdown with `name` + `description` frontmatter, usable by any agent that reads skills. `plugin.json` at the root is a compatibility manifest for clients that require one — it does not make this repo owned by any product.

## Hard rules

1. **`plugin.json` `skills` array is the source of truth for what ships.** Every skill that should be installable must appear there, by directory path. A skill directory that is not in the array is unpublished.
2. **Keep the array minimal and valid.** Only list directories that contain a `SKILL.md`. Do not list nested paths, drafts, or archived skills.
3. **README is orientation, not a catalogue.** Do not maintain a per-skill table or a per-skill changelog in `README.md`. Skill inventory lives in `plugin.json`; per-skill detail lives in the skill's own `SKILL.md`.
4. **Skill name = directory name.** Frontmatter `name` must match `skills/<dir>`. Avoid colliding with a builtin skill of the client you use.
5. **No phantom commands.** If an upstream full version ships scripts, inline the command as an example or label it "only with the full version installed". Never reference a file that is not in this repo as if it were.
6. **Pointer, not copy.** Reference large upstream databases by official source. Do not embed data dumps.
7. **Useful fallback, no invented output.** A skill missing its upstream tooling must still produce a real, labelled answer.
8. **Bump `version` in `plugin.json` when a skill changes** that people may already have pinned. Clients pin to a commit; a version bump does not auto-update an install, it only marks the change.

## When editing

- Read the existing `SKILL.md` in full before changing it; preserve sections you are not asked to change.
- Write, then read the file back and grep for the change before reporting it done. `ok:true` proves the write ran, not that the content is right.
- Never rewrite `AGENTS.md` to describe a folder structure that does not exist on disk; verify with a directory listing first.

## Commit style

One commit per intent. Say what changed and why in one line, e.g. `Skills: add <name>` or `Manifest: unpublish <name>`.
