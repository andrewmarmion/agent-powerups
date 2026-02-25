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

### Step 2: Sequential Per-Branch CR Loop

Process each branch bottom-up — one at a time, base of stack first.

For each branch:

#### 2a. Launch CodeRabbit

```bash
coderabbit --prompt-only --type committed --base <previous-branch>
```

`<previous-branch>` is the immediately preceding branch in the stack — trunk for the first ticket, the previous ticket's branch for all others. **Never use trunk as `--base` for any ticket except the first.**

#### 2b. Wait for Review

Wait for this review to complete before proceeding. Do not move to the next branch while this review is in-flight.

If CodeRabbit times out or is rate-limited: this is the **failure point**. Process and `gt sync` all branches below this point that have already been reviewed, then stop.

Report and stop:

```
CR failed for:
- LIN-125 (rate limited)
- LIN-126 (not started)

Submitting passing tickets only.
```

Proceed to Step 3 with only the passing tickets. Report the re-invoke command:

```
Re-invoke with: /agent-powerups:finishing-stacked-prs <failure-point-branch>
```

#### 2c. Process Findings

Invoke `agent-powerups:receiving-code-review` for this ticket's findings — discuss every finding before applying any fix.

#### 2d. Verify Tests

Run the project's full test suite after agreed fixes are applied. Do not proceed if tests fail.

#### 2e. Restack

```bash
gt sync
```

Then move to the next branch up the stack.

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
- Process CR one branch at a time — never move to the next branch while a review is in-flight
- `--base` must be the immediately preceding branch — never trunk except for the first ticket
- Submit only the contiguous passing block from the base up to the first failure point
- The submit decision belongs to the user — never auto-submit
- Only clean up worktree when the user explicitly asks

## Integration

**Called by:** agent-powerups:executing-linear-plan (Step 4)

**Calls:**
- `agent-powerups:receiving-code-review` — for any outstanding CR findings
