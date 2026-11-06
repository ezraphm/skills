# estack

A personal, distributed **skill stack**. Every skill is a standalone `skills/<name>/SKILL.md` — plain Markdown, no runtime, no vendor — usable by any agent that reads skills.

The repo also satisfies the plugin manifest contract, so the same tree installs as a plugin where a client requires one. The manifest is a compatibility layer; the skills are the product.

```
plugin.json      manifest + the list of published skills
AGENTS.md        rules for agents working in this repo
skills/<name>/   one SKILL.md per skill
```

## Rules and inventory

- **Working rules:** [`AGENTS.md`](AGENTS.md)
- **Published skill list:** the `skills` array in [`plugin.json`](plugin.json) — that array, not this README, is the inventory.

## Reaching a skill

- **Any agent that reads skills:** point it at the `skills/<name>/SKILL.md` path, or `/`-invoke the skill by name if the client supports it.
- **A client requiring a plugin manifest:** install from this repo URL. The repo must be **public**, and the install **pins to a commit** — to pick up later edits you must remove and re-add, not just bump `version`.

## Design rules

Skills here are self-contained: no phantom commands, upstream databases referenced by pointer instead of copied, a usable fallback when tooling is absent, and no invented output. Full detail in [`AGENTS.md`](AGENTS.md).
