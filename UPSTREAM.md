# Upstream Tracking

This plugin was created by copying the skills from [superpowers](https://github.com/obra/superpowers).

| Field | Value |
|-------|-------|
| Repository | https://github.com/obra/superpowers |
| Commit | e16d611eee14ac4c3253b4bf4c55a98d905c2e64 |
| Date copied | 2026-02-21 |
| Version | 4.3.0 |

## Comparing with upstream

To see what has changed in superpowers since this plugin was created:

```bash
git clone https://github.com/obra/superpowers /tmp/superpowers
cd /tmp/superpowers
git log e16d611eee14ac4c3253b4bf4c55a98d905c2e64..HEAD --oneline
git diff e16d611eee14ac4c3253b4bf4c55a98d905c2e64 HEAD -- skills/
```

## What was changed from upstream

- `skills/using-superpowers/` renamed to `skills/using-agent-powerups/`
- `skills/using-agent-powerups/SKILL.md` frontmatter: `name` changed to `using-agent-powerups`
- `hooks/session-start.sh`: updated to reference `using-agent-powerups`, removed superpowers legacy migration check
- All skill namespace references changed from `superpowers:` to `agent-powerups:` throughout skills and commands
- `.claude-plugin/plugin.json`: new file (replaces superpowers plugin.json)
- `.claude-plugin/marketplace.json`: new file (self-referencing marketplace)
- `UPSTREAM.md`: new file (this file)
- `README.md`: new file (replaces superpowers README)
- Removed: `RELEASE-NOTES.md`, `.opencode/`, `.codex/`, `.github/`, `tests/`, `docs/`
