---
name: executing-linear-plan
description: Use when you have a Linear-annotated implementation plan to execute with stacked Graphite branches and CodeRabbit review per ticket
---

# Executing Linear Plan

## Overview

Executes a tickets file ticket by ticket, creating stacked Graphite branches and launching CodeRabbit in the background per ticket. CR processing and submission are handled by finishing-stacked-prs once all tickets are coded.

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

Repeat for each ticket in the tickets file:

#### 2a. Create Branch

```bash
gt branch create <branch-name-from-plan>
# e.g. gt branch create andrew/LIN-123-add-data-model
```

#### 2b. Update Linear Status

Using the Linear MCP, update the ticket's issue state to "In Progress":

```
save_issue(id: <ticket-id-from-plan>, state: "In Progress")
```

The ticket ID is in the tickets file header (e.g. `## Ticket 1: Title — LIN-123`).

#### 2c. Execute Tasks

Follow the same execution pattern as `agent-powerups:executing-plans` — mark in_progress, follow each step exactly, run verifications as specified, stop when blocked.

Do not proceed to the next ticket if any task fails or is unclear.

Once all tasks for the ticket are complete, commit with this format:

```
<ticket_no>: short imperative description

- Bullet summarising first change covered by this ticket
- Bullet summarising second change
- ...
```

Pull the subject and body bullets directly from the ticket's section in the tickets file — the scope summary and task list are already there. Example:

```
LIN-123: add Conversation/Reply Core Data model and fetch helpers

- Add Conversation and Reply entities to RoverCommHubModel.xcdatamodeld
- Create InboxPersistentContainer+Conversations.swift with fetch helpers
- Add ConversationFetchTests with 5 unit tests
```

#### 2d. Verify Tests Pass

Run the project's full test suite. Do not proceed if tests fail.

### Step 3: Batch Checkpoint (Every 3 Tickets)

Pause and report:
- Tickets completed, branch names
- Ask: "Ready to continue, or do you want to review the branches locally first?"

### Step 4: Complete

After all tickets are coded and tests pass, announce:

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
- `agent-powerups:finishing-stacked-prs` — after all tickets complete
