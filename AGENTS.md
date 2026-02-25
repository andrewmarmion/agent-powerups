# Agent Guide — agent-powerups

This repo is a Claude Code plugin containing development workflow skills. All changes are edits to markdown files. There is no application code, no test suite, and no Linear/Graphite workflow.

## Directory map

```
skills/<skill-name>/SKILL.md     — skill content (one per skill)
skills/<skill-name>/*.md         — supporting reference files for that skill
lib/skills-core.js               — utilities for loading and validating skill files
.claude-plugin/plugin.json       — plugin metadata and version
.claude-plugin/marketplace.json  — marketplace metadata and version (must match plugin.json)
agents/                          — agent prompt files
commands/                        — slash command definitions
docs/plans/                      — design docs from brainstorming sessions
```

## Task: Edit an existing skill

1. Read the skill file at `skills/<skill-name>/SKILL.md`
2. Make the targeted change — do not rewrite sections that aren't in scope
3. Keep the frontmatter (`name`, `description`) intact
4. All cross-skill references use the `agent-powerups:` namespace (e.g. `agent-powerups:brainstorming`)
5. Bump the version (see below)
6. Commit

## Task: Add a new skill

1. Create `skills/<skill-name>/SKILL.md`
2. Use the `agent-powerups:writing-skills` skill — it contains the authoring conventions
3. All references to other skills use the `agent-powerups:` namespace
4. Validate the frontmatter parses correctly:
   ```bash
   node --input-type=module <<'EOF'
   import { extractFrontmatter } from './lib/skills-core.js';
   const result = extractFrontmatter('skills/<skill-name>/SKILL.md');
   console.log(result);
   if (!result.name || !result.description) { console.error('FAIL: missing name or description'); process.exit(1); }
   console.log('OK');
   EOF
   ```
   Both `name` and `description` must be non-empty. If either is missing, fix the frontmatter before proceeding.
5. Bump the version (see below)
6. Commit

## Task: Bump the version

**Two files must be updated together — they must always stay in sync:**

- `.claude-plugin/plugin.json` — `"version"` field
- `.claude-plugin/marketplace.json` — `"version"` field inside the `plugins` array

This repo uses semantic versioning. Skill edits and fixes are patch bumps (e.g. `1.0.3` → `1.0.4`).

## Task: Test locally

```bash
claude --plugin-dir ./agent-powerups
```

This loads the plugin from the local directory. Verify the skill loads and behaves as expected before committing.

## Approved skills for this repo

| Skill | When to use |
|-------|-------------|
| `agent-powerups:brainstorming` | Before making any non-trivial change — design first, implement second |
| `agent-powerups:writing-skills` | When authoring or editing a skill |
| `agent-powerups:verification-before-completion` | Before claiming work is done |
| `agent-powerups:systematic-debugging` | When a skill isn't behaving as expected |

## Do not use in this repo

| Skill | Reason |
|-------|--------|
| `agent-powerups:writing-plans` | Overkill — all changes are skill file edits; the brainstorming design doc is sufficient to go straight to implementation |
| `agent-powerups:executing-plans` | Same reason — no plan file is needed for targeted markdown edits |
| `agent-powerups:decomposing-into-tickets` | This repo has no Linear integration — invoking this would attempt to create tickets that don't belong here |
| `agent-powerups:executing-linear-plan` | No Linear tickets, no Graphite stack — do not use |
| `agent-powerups:finishing-stacked-prs` | No stacked PR workflow in this repo |
| `agent-powerups:reviewing-stacked-prs` | No stacked PR workflow in this repo |
