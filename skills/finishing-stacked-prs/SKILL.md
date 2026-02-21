---
name: finishing-stacked-prs
description: Use when all Linear tickets are implemented and you need to sync, verify tests, and optionally submit the Graphite stack - always asks before submitting to allow time for manual testing
---

# Finishing Stacked PRs

## Overview

Completes the stacked PR workflow after all tickets are implemented — syncs the stack, verifies tests, resolves outstanding CodeRabbit reviews, and offers submission or continued manual testing.

**Announce at start:** "I'm using the finishing-stacked-prs skill to complete this work."

## Process

### Step 1: Sync Then Verify

```bash
gt sync   # rebase stack against latest remote base first
```

- If `gt sync` produces conflicts: **stop immediately**, report the conflicts, ask for resolution
- Once sync is clean: run the project's full test suite
- If tests fail: **stop**, report failures, do not proceed

### Step 2: Resolve Outstanding CR Reviews

Check for any still-running CodeRabbit background tasks.

If any remain:
1. Wait for completion
2. Invoke `agent-powerups:receiving-code-review` to process findings — discuss every finding before applying any fix
3. After agreed fixes: re-run tests, then `gt sync`

Only proceed when all CR reviews are resolved and tests pass.

### Step 3: Submit Decision

```
All tickets implemented, tests passing, stack synced.

Would you like to:
1. Submit the full stack now
2. Keep branches local for manual testing first

Which option?
```

**Option 1 — Submit now:**
```bash
gt submit --stack --no-interactive
```

Then proceed to Step 4.

**Option 2 — Keep local:**
Report branch names and worktree path. Remind user to re-invoke `agent-powerups:finishing-stacked-prs` when ready to submit. Leave worktree intact.

### Step 4: Stack Summary (After Submission)

```
Stack submitted:

LIN-123 · andrew/LIN-123-add-data-model  → PR #45
LIN-124 · andrew/LIN-124-api-endpoints   → PR #46
LIN-125 · andrew/LIN-125-ui-layer        → PR #47
```

### Step 5: Cleanup

Ask: "Keep the worktree open while reviews are in progress, or clean it up now?"

- **Keep:** Report worktree path, done.
- **Clean up:**
  ```bash
  git worktree remove <worktree-path>
  ```

### Step 6: Hand Off

"When you're ready for GitHub review, invoke `agent-powerups:reviewing-stacked-prs`."

## Remember

- Always `gt sync` **before** running tests — test the rebased state
- Never submit with failing tests
- The submit decision belongs to the user — never auto-submit
- Only clean up worktree when the user explicitly asks

## Integration

**Called by:** agent-powerups:executing-linear-plan (Step 4)

**Calls:**
- `agent-powerups:receiving-code-review` — for any outstanding CR findings
