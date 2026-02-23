---
name: reviewing-stacked-prs
description: Use when a Graphite stack has open PRs ready for GitHub review - accepts optional branch argument to start from a specific PR, checks all PRs in one pass, processes available feedback bottom-up and flags pending reviews
---

# Reviewing Stacked PRs

## Overview

A standalone skill for handling the GitHub review phase of a submitted stack. Manually invoked when ready — decoupled from the build flow to accommodate CodeRabbit rate limiting and time for manual testing.

**Announce at start:** "I'm using the reviewing-stacked-prs skill to work through the review."

**Assumes:** Checked out at the top of the stack. PRs already submitted via `gt submit`.

**Optional argument:** Branch name to start from (e.g. `andrew/LIN-125-slug`). If not provided, starts from the base of the stack.

**No plan file required** — all state is discovered from `gt` and `gh`.

## Process

### Step 1: Discover Stack State

```bash
gt log short    # full stack from trunk to current branch
```

For each branch in the stack (bottom to top):
```bash
gh pr view <branch> --json number,title,url,reviews,comments,reviewDecision,state
```

Build a complete picture: trunk branch, all stacked branches in order, PR numbers, review status.

### Step 2: Report Stack Health

```
Stack review status:

LIN-123 · PR #45 · CodeRabbit ✓ · 2 comments · awaiting approval
LIN-124 · PR #46 · CodeRabbit ⏳ (still reviewing)
LIN-125 · PR #47 · CodeRabbit ✗ (timed out) · 0 comments
```

If any CodeRabbit reviews timed out: warn the user — they may want to trigger a re-review before proceeding. Do not silently skip timed-out reviews.

If reviews are still pending: suggest re-invoking this skill when they're ready rather than waiting in this session.

### Step 3: Work Through All PRs Bottom-Up

Process all PRs in a single pass starting from the base of the stack (or the branch argument if provided). Do not stop early because some reviews are still pending — handle what is available and flag the rest.

For each PR, bottom-up:

**If feedback is available:**
1. Show all review comments for this PR
2. Invoke `agent-powerups:receiving-code-review` to process findings — treat all reviewers (CodeRabbit and human) as external reviewers, discuss **every** finding before applying any fix
3. Reply to resolved GitHub comments in the PR thread:
   ```bash
   gh api repos/{owner}/{repo}/pulls/comments/{comment-id}/replies \
     -f body="Fixed in <commit-sha>"
   ```
4. Run tests after all agreed fixes applied
5. `gt sync` to restack branches above
6. `gt submit` to update the PR

**If review is still pending:**
Note it and continue to the next PR — do not skip it in the final report.

**Stop if:**
- A fix introduces a test failure — stop, report, ask how to proceed
- A comment flags an architectural issue — raise with user, do not apply without discussion
- `gt sync` produces conflicts — resolve before continuing

### Step 4: Final State

Report the complete picture — every PR in the range, handled or pending:

```
Review complete:

LIN-123 · PR #45 · all feedback addressed · updated
LIN-124 · PR #46 · no changes needed
LIN-125 · PR #47 · review still pending

Ready to merge (LIN-123, LIN-124). Merge bottom-up via Graphite: LIN-123 first.

Re-invoke for pending reviews: /agent-powerups:reviewing-stacked-prs andrew/LIN-125-slug
```

Only show the re-invoke line if there are pending reviews.

## Remember

- Always work bottom-up — base of stack first
- Every finding is a discussion, not an automatic fix
- `gt sync` after every fix to keep the stack coherent
- Reply to GitHub comments in their thread, not as top-level PR comments
- Timed-out CodeRabbit reviews must be flagged, not silently skipped

## Integration

**Called by:** User, manually, after `agent-powerups:finishing-stacked-prs`

**Calls:**
- `agent-powerups:receiving-code-review` — for all review findings
