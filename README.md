# agent-powerups

A Claude Code plugin providing development workflow skills for consistent, high-quality AI-assisted development.

## Skills included

| Skill | Purpose |
|-------|---------|
| `brainstorming` | Turn ideas into designs before writing code |
| `writing-plans` | Create bite-sized implementation plans |
| `executing-plans` | Work through plans task-by-task |
| `test-driven-development` | Red/green/refactor TDD workflow |
| `systematic-debugging` | Root-cause-first debugging process |
| `subagent-driven-development` | Parallel subagent execution with review |
| `dispatching-parallel-agents` | Coordinate independent parallel tasks |
| `requesting-code-review` | Structured code review process |
| `receiving-code-review` | Evaluate and apply review feedback |
| `finishing-a-development-branch` | Complete and integrate development work |
| `verification-before-completion` | Verify work before claiming it's done |
| `writing-skills` | Author new skills for this plugin |
| `using-git-worktrees` | Isolated feature work in git worktrees |

## Installation

### 1. Add the marketplace (one-time setup)

```
/plugin marketplace add andrewmarmion/agent-powerups
```

### 2. Install the plugin

```
/plugin install agent-powerups@agent-powerups
```

### 3. Restart Claude Code

Restart your Claude Code session to activate the plugin.

## Getting updates

```
/plugin marketplace update agent-powerups
```

## Local development / testing

```bash
claude --plugin-dir ./agent-powerups
```

## Customising skills

Skills are markdown files in `skills/<skill-name>/SKILL.md`. Edit them to match your team's workflows, then bump the version in `.claude-plugin/plugin.json` and push.

## Upstream

This plugin is based on [superpowers](https://github.com/obra/superpowers) by Jesse Vincent. See [UPSTREAM.md](UPSTREAM.md) for the baseline commit and change log.
