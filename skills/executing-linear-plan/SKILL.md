---
name: executing-linear-plan
description: Use when you have a Linear-annotated implementation plan to execute with stacked Graphite branches and CodeRabbit review per ticket
---

# Executing Linear Plan

## Overview

Executes a ticket-annotated plan ticket by ticket, creating stacked Graphite branches, running CodeRabbit in the background, discussing every finding with the user before applying any fix, and submitting PRs.

**Announce at start:** "I'm using the executing-linear-plan skill to implement this plan."

**Requires:** Graphite CLI (`gt`), CodeRabbit CLI (`coderabbit`), Linear MCP connected, tickets file at `docs/plans/YYYY-MM-DD-<feature-name>-tickets.md`.

**Never start on main/master without explicit user consent.**

## Process

### Step 1: Load and Review Plan

1. Read the tickets file (`docs/plans/YYYY-MM-DD-<feature-name>-tickets.md`)
2. Review critically — identify any concerns before starting
3. Confirm `gt` is configured and the worktree is on the correct base branch:
   ```bash
   gt trunk        # confirm trunk branch
   git branch --show-current   # confirm current position
   ```
4. If concerns: raise them before starting
5. If no concerns: create a todo entry per ticket and proceed

### Step 2: Per-Ticket Loop

Repeat for each ticket in the annotated plan:

#### 2a. Create Branch

```bash
gt branch create <branch-name-from-plan>
# e.g. gt branch create andrew/LIN-123-add-data-model
```

#### 2b. Execute Tasks

Follow the same execution pattern as `agent-powerups:executing-plans` — mark in_progress, follow each step exactly, run verifications as specified, stop when blocked.

Do not proceed to the next ticket if any task fails or is unclear.

#### 2c. Verify Tests Pass

Run the project's full test suite. Do not proceed if tests fail.

#### 2d. Launch CodeRabbit in Background

```bash
coderabbit --prompt-only --type committed --base <parent-branch>
```

Note the background task ID. The parent branch is the branch this ticket is stacked on (previous ticket's branch, or trunk for the first ticket).

#### 2e. Checkpoint: Process Previous Ticket's CR Findings

Before moving to the next ticket, check if CodeRabbit has finished on the **previous** ticket:

- **Finished:** Invoke `agent-powerups:receiving-code-review` to process findings. Treat CodeRabbit as an external reviewer — discuss **every** finding with the user before applying any fix. After agreed fixes: run `gt sync`, re-run tests.
- **Still running:** Note it and continue — check again at the next checkpoint.

#### 2f. Submit

```bash
gt submit --no-interactive
```

### Step 3: Batch Checkpoint (Every 3 Tickets)

Pause and report:
- Tickets completed, Linear issue IDs, PR links
- Any outstanding CR reviews not yet processed
- Ask: "Ready to continue, or do you want to review the stack in Graphite first?"

### Step 4: Complete

After all tickets done and all CR reviews resolved, announce:

"Invoking `agent-powerups:finishing-stacked-prs` to complete this work."

**REQUIRED SUB-SKILL:** Use agent-powerups:finishing-stacked-prs

## Stop Conditions

Stop immediately and raise with the user when:
- Tests fail after CR fixes — do not retry blindly
- `gt sync` produces conflicts — show conflicts, ask for resolution
- A CR finding flags an architectural issue — raise it, do not just apply the fix
- Any task cannot be completed as specified — stop, ask, do not guess
- Plan has critical gaps preventing a task from starting

## Integration

**Called by:** agent-powerups:decomposing-into-tickets (handoff)

**Calls:**
- `agent-powerups:executing-plans` — referenced for inner task execution pattern
- `agent-powerups:receiving-code-review` — for all CodeRabbit findings, every ticket
- `agent-powerups:finishing-stacked-prs` — after all tickets complete
