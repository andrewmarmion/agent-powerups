---
name: decomposing-into-tickets
description: Use after writing-plans when splitting a plan into Linear tickets and stacked PRs - groups tasks into coherent shippable slices under 500 lines, creates Linear sub-issues via MCP after user approval
---

# Decomposing Into Tickets

## Overview

Takes a written plan and re-groups its tasks into Linear-sized tickets — coherent, shippable slices with passing tests and <500 line diffs — then creates Linear sub-issues via MCP after user approval.

**Announce at start:** "I'm using the decomposing-into-tickets skill to create Linear tickets."

**Requires:** Linear MCP connected. Written plan at `docs/plans/YYYY-MM-DD-<feature-name>.md`.

## Process

### Step 1: Read and Analyse the Plan

Load the plan from `docs/plans/YYYY-MM-DD-<feature-name>.md`.

Identify natural groupings — tasks that form a coherent unit:
- Related data model changes that ship together
- A complete API surface
- A self-contained UI layer
- Infrastructure that enables subsequent work

Estimate line diff per grouping. If a group exceeds ~500 lines, split it further.

### Step 2: Present Ticket Breakdown for Approval

Show the proposed breakdown before touching Linear:

```
Proposed tickets:

Ticket 1: [title]
  Tasks: 1.1, 1.2, 1.3
  Scope: [1-2 sentence description]
  Est. diff: ~200 lines

Ticket 2: [title]
  Tasks: 2.1, 2.2
  Scope: [1-2 sentence description]
  Est. diff: ~350 lines
```

Ask: "Does this breakdown look right, or would you like to adjust the groupings?"

**Do not touch Linear until the user approves the breakdown.**

### Step 3: Confirm Parent Ticket

- Check conversation context for a parent Linear ticket ID/URL provided during brainstorming
- If found: "Using parent ticket LIN-XXX — is that correct?"
- If not found: ask for it now, or offer to create a new parent ticket

### Step 4: Confirm Assignee and Labels

Ask for:
- Developer assignee (Linear username)
- Label(s) — e.g. iOS, Android, Backend, or other

### Step 5: Create Linear Sub-Issues via MCP

For each approved ticket, create a sub-issue with:
- **Title:** concise, imperative
- **Description:** scope summary and which plan tasks it covers
- **Acceptance criteria:** derived from task verification steps in the plan
- **Assignee:** from Step 4
- **Label(s):** from Step 4
- **Parent:** ticket confirmed in Step 3

After creation, call `get_issue` to retrieve Linear's generated git branch name for each ticket.

### Step 6: Annotate the Plan File

Add Linear metadata to the plan document for each ticket group:

```markdown
### Ticket 1: [title] — LIN-123
Branch: andrew/LIN-123-add-data-model
Tasks: 1.1, 1.2, 1.3
```

Save and commit the annotated plan:

```bash
git add docs/plans/<filename>.md
git commit -m "chore: annotate plan with Linear ticket IDs"
```

### Step 7: Hand Off

"Tickets created. Invoke `agent-powerups:executing-linear-plan` to begin implementation."

## Remember

- Never create Linear tickets until the user approves the breakdown
- Each ticket must be a complete, shippable slice — tests written and passing, <500 line diff
- Branch name comes from Linear (`get_issue` after creation) — do not construct it manually
- Parent ticket may have been provided during brainstorming — check context before asking
