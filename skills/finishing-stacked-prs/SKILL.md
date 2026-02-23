---
name: finishing-stacked-prs
description: Use when all Linear tickets are implemented - accepts optional branch argument to resume mid-stack, waits for all CR reviews before processing, handles partial submission up to first failure, always asks before submitting
---

# Finishing Stacked PRs

## Overview

Completes the stacked PR workflow after all tickets are implemented — waits for all CR reviews, processes findings bottom-up on a stable stack, and submits.

**Announce at start:** "I'm using the finishing-stacked-prs skill to complete this work."

**Optional argument:** Branch name to resume from (e.g. `andrew/LIN-125-slug`). If not provided, starts from the base of the stack.

## Process

### Step 1: Sync Then Verify

```bash
gt sync   # rebase stack against latest remote base first
```

- If `gt sync` produces conflicts: **stop immediately**, report the conflicts, ask for resolution
- Once sync is clean: run the project's full test suite
- If tests fail: **stop**, report failures, do not proceed

### Step 2: Wait for All CR Reviews

Check all running CodeRabbit background tasks. **Wait for every outstanding review to complete before processing any.** Do not `gt sync` while any review is in-flight.

Once all reviews have settled, categorise each ticket as:
- **Passed** — CR completed, findings ready to process (or no findings)
- **Failed** — CR timed out or rate limited

Identify the **failure point**: the lowest ticket in the stack that failed. All tickets from the failure point upwards will not be processed in this pass.

#### If all tickets passed:

Process findings bottom-up — one ticket at a time, base of stack first:
1. Invoke `agent-powerups:receiving-code-review` for this ticket's findings — discuss every finding before applying any fix
2. Run tests after agreed fixes applied
3. `gt sync` to restack branches above
4. Move to next ticket up the stack

Only proceed to Step 3 when all findings are resolved and tests pass.

#### If there is a failure point:

Process and `gt sync` all tickets below the failure point as above.

Then report and stop:

```
CR failed for:
- LIN-125 (rate limited)
- LIN-126 (rate limited)

Submitting passing tickets only.
```

Proceed to Step 3 with only the passing tickets. At the end, report the re-invoke command:

```
Re-invoke with: /agent-powerups:finishing-stacked-prs <failure-point-branch>
```

### Step 3: Submit Decision

```
Tests passing, stack synced.

Would you like to:
1. Submit now
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
- Wait for **all** CR reviews before processing any — never `gt sync` while reviews are in-flight
- Submit only the contiguous passing block from the base up to the first failure point
- The submit decision belongs to the user — never auto-submit
- Only clean up worktree when the user explicitly asks

## Integration

**Called by:** agent-powerups:executing-linear-plan (Step 4)

**Calls:**
- `agent-powerups:receiving-code-review` — for any outstanding CR findings
