---
allowed-tools: Bash, Read, Grep, Glob, mcp__linear-server__list_issues, mcp__linear-server__save_issue, mcp__linear-server__list_teams, mcp__linear-server__list_projects
description: Create a Linear ticket. Seed from $ARGUMENTS or interactively. Follows the repo's issue template if one exists, otherwise Problem/Solution/AC/Implementation Suggestions. Defaults to the Core Product team.
---

# Create ticket

Create a Linear ticket in the Core Product team. Use the repo's issue template if it has one, otherwise fall back to the standard structure.

## Input

`$ARGUMENTS` — optional description / problem statement. If absent, ask the user for one in chat before drafting.

## Defaults

- **Team**: Core Product (`COR`, team ID `82863d93-f1a0-470f-a6c5-d61f9a2fe258`).
- **Priority**: No priority (the user's default — most tickets land here).
- **Status**: default for the team (typically Backlog or Todo).

The user may override any of these explicitly. Don't ask about them; defaults are right unless the input says otherwise.

## Flow

1. **Get the seed.** From `$ARGUMENTS` or by asking the user. Capture: the problem, any context, any specifics the user mentions.

2. **Ask about duplicate check.** Single question: *"Should I check Linear for similar tickets first?"* Don't auto-search — sometimes the user already knows it's new work.
   - If **yes**: search Linear (`list_issues` filtered by team + relevant keywords). Show up to 5 candidates with ID + title + state. Ask the user whether to continue, link to an existing one, or merge contexts.
   - If **no**: skip directly to drafting.

3. **Find the template.** Look in the current repo for issue templates:
   - `.github/ISSUE_TEMPLATE/*.md` / `*.yml`
   - `.github/ISSUE_TEMPLATE.md`
   - `docs/writing-linear-issues.md` (sway repo — read for guidance, not a template per se)

   Use the template's structure if found. Otherwise default to:

   ```
   ## Problem
   ## Solution
   ## Acceptance Criteria
   ## Implementation Suggestions
   ```

4. **Draft the body.** Apply the user's ticket-writing rules:

   - **AC is outcome-focused.** No implementation details, function names, dispatch logic, or test cases in AC. ACs describe *what done looks like from a user/system perspective*, not *how to get there*.
   - **Implementation details go in a separate section** ("Implementation Suggestions" or equivalent). The agent doing the work will use them as a starting point, not gospel.
   - **Don't restate relationship info.** Blockers, parent/child, related issues, dependencies — Linear tracks these via fields. Don't duplicate in the body. If the user mentions a relationship, capture it as a link or note we'll set the relationship field.
   - **AC is positive, not blame-y.** Describe the target state; don't litigate the past.
   - **Keep it MVP.** The simplest version that delivers the outcome. Refactors and gold-plating belong in follow-up tickets.
   - **Header level doesn't matter.** `##` vs `###` is fine either way — pick one and stay consistent within the ticket.

5. **Create the ticket** via `save_issue` (Linear MCP) with the drafted body, in the Core Product team, with the default priority. **Don't preview-for-approval first** — just create. The user can edit in Linear if anything needs sharpening.

6. **Report.** Ticket ID, title, URL. Brief — one or two lines.

## Out of scope

- Setting blockers / parents / related issues via Linear fields. Mention what the user said about relationships in the report so they can wire those up in Linear (or in a follow-up `save_issue` call if they ask).
- Status changes, comments, or substantive updates to existing tickets. Those need the user's approval per global rules.
- Tickets in teams other than Core Product unless the user explicitly says so.
