---
allowed-tools: mcp__linear-server__list_cycles, mcp__linear-server__list_issues, mcp__linear-server__get_issue, mcp__linear-server__get_team, mcp__linear-server__list_issue_statuses
description: Generate a weekly cycle update Slack message summarizing the previous cycle and previewing the current one. Use when user wants to create their Monday cycle update.
---

# Weekly Cycle Update

Generate a Slack message draft summarizing the previous Linear cycle's results and the current cycle's plan. The audience is primarily CTO and Product Lead, but the message is visible to the whole team — so be factual, concise, and positive about momentum where appropriate.

## Step 1 — Fetch Linear data

Gather all the raw material from Linear before talking to the user.

### Cycles

Cycles run Monday through Sunday. This command can be run Friday through Monday.

1. List cycles for the **Core Product (COR)** team (ID: `82863d93-f1a0-470f-a6c5-d61f9a2fe258`).
2. Determine which two cycles to summarize based on today's day of week:
   - **Monday:** The *current* cycle (just started) is the "upcoming" cycle. The *previous* cycle (just ended) is the "recap" cycle.
   - **Friday–Sunday:** The *current* cycle (still in progress) is the "recap" cycle. The *next* cycle (by number) is the "upcoming" cycle.
3. For each of the two cycles, note: title, number, start/end dates, progress history (`completedIssueCountHistory`, `issueCountHistory`, `completedScopeHistory`, `scopeHistory`).

### Issues for both cycles

For each cycle:

1. List all issues assigned to that cycle.
2. For each issue, capture: identifier, title, state (status name + type), assignee, priority, creation date, and parent issue (if any).
3. Group by status category:
   - **Completed:** status type = completed (Done) **OR** status is In Review / Mergable. Treat "In Review" and "Mergable" as effectively completed for reporting purposes — the individual has done their work, and waiting on review is not their responsibility. When reporting on the recap cycle, also check the upcoming cycle's issues for In Review / Mergable items that the person likely pushed during the recap cycle.
   - **In flight:** status is In Progress only
   - **Planned / not started:** status type = unstarted (Todo)
   - **Cancelled / removed:** status type = canceled (Canceled, Stale, Duplicate)
   - **Carried over:** issues from the previous cycle still in a non-terminal state that also appear in the current cycle

### Previous cycle: identify reactive work

Flag issues in the previous cycle where the creation date is *after* the cycle start date AND the issue is not a child of another issue already in the cycle. These are reactive/unplanned items that came in mid-cycle.

### Projects and milestones

1. List active projects for the COR team.
2. For each project, note: name, status, progress, current milestone (if any), and milestone progress.
3. Map which cycle issues belong to which projects — this reveals the theme of each person's work.

### Per-person summary

Group the previous cycle's issues by assignee. For each person, identify:
- What they completed
- What themes/projects their work fell under
- Any notable reactive work they picked up

Do the same for the current cycle to show who is working on what.

## Step 2 — Interview the user

Present a concise summary of what you found:
- Per-person themes and highlights (include In Review items as completed work)
- Reactive work that came in mid-cycle
- Active projects and their current status (do NOT report milestone/project completion percentages — these aren't meaningful until a project is fully specced)
- Current cycle plan: who is doing what, toward which projects

Then ask:

> Here's what I'm seeing from Linear. Before I draft the update:
> - Any wins, blockers, or context I should weave in that isn't obvious from the tickets?
> - Anything to reframe or de-emphasize?
> - Any shout-outs?

Wait for the user's response before proceeding.

## Step 3 — Compose the Slack message

Write the message using **Slack mrkdwn** formatting (not GitHub markdown). Key differences:
- Bold: `*text*` (single asterisks)
- Italic: `_text_`
- Links: `[text](url)` (standard markdown links)
- Lists: plain `- ` or `• ` (no nested indentation)
- Code: backticks work the same
- Section dividers: use a blank line, not `---`
- No headings syntax — use *bold text* on its own line as section headers

### Message structure

The message has three sections in this order: (1) project updates, (2) finishing cycle highlights, (3) new cycle highlights. Lead with the strategic view so leadership gets the big picture first.

```
*Core Product Update — Cycle [N] :arrow_right: Cycle [N+1]*

*Active Projects*

*[Project name]* — [current milestone name] ([progress %])
[1-2 sentences: milestones hit or missed, commentary on current status, what's moving]
[repeat for each active project]

*Cycle [N] Highlights* ([date range], [on-call person] on-call)

*What folks have been working on*
* [Person] [strong verb] [what they did] ([ticket ID]) [and context about what it means]. Also [continuing/started] [next thing] ([ticket ID]).
[repeat per person — group each person's work by theme]

*On-call / Reactive*
* [Person] handled [description] ([ticket ID], resolved [timeframe]).
[repeat]

*[Other theme — Tooling, Infra, Security, Planning, etc.]* — only if applicable
* [Person] [what they did] ([ticket ID]).

*Cycle [N+1]* ([date range], [on-call person] on-call)

*What folks are focused on*
* [Person] is [strategic intent — what they're pushing toward, not just ticket names] ([ticket IDs]).
[repeat per person — group by theme]

*Milestones we're targeting*
* [Milestone name] ([project]) — [what needs to happen to hit it]
[repeat]

[Optional closing line inviting leadership input on priorities]
```

### Writing style rules

These are non-negotiable:

- **Thematic sections, not status-based.** Group by project/initiative ("Better Launches", "On-call / Support", "Tooling & Infra"), never by workflow state ("Completed", "In Progress", "Carried Over").
- **Person-led prose.** Each bullet starts with a name and reads as a sentence: "Josh landed manual save (COR-41) and extracted a reusable save workflow composable (COR-190)." The ticket ID is a parenthetical citation, not the lead.
- **Specific, varied verbs.** Use "landed", "shipped", "pivoted", "drove", "cut through", "broke down", "handled", "built". Never generic "completed" or "worked on".
- **Context over titles.** Don't parrot the ticket title — explain what the work means in plain language: "filtering out expired-token false positives" not "COR-178 GraphQL permission violations noise".
- **Honest about setbacks.** If something slipped, say so matter-of-factly with the reason. Self-aware asides are fine: "We justified the side quest internally by telling ourselves how much faster we expect to be with parallel sessions."
- **Reactive work is a feature.** On-call and unplanned support work gets its own section, showing the team's responsiveness and resolution speed. Mention follow-up tickets filed if any.
- **Future cycle = strategic intent.** Don't list tickets for next cycle — describe what each person is pushing toward: "Josh is on technical planning to complete Better Launches, supporting Audrey getting a head start on Modules."
- **No emoji.** Use plain `*bold*` for section headers, `*` for bullets. No `:emoji:` codes.
- **No metrics-first framing.** Don't lead with "12/15 completed, 80% scope". Convey progress narratively.
- **First names only.** For assignees. Don't @mention people in the draft.
- **Link every Linear reference.** Every mention of a project, milestone, or issue should be a clickable link to that item in Linear — not just a name or ID in plain text.
- **Vary your verbs.** Don't repeat the same verb (e.g. "drove") across multiple bullets. Mix it up: "shipped", "pushed", "got...to review", "landed", "stood up", "built", "handled".
- **Use bullet points to separate topics.** In the Active Projects section, use bullet points within each project to separate distinct topics (progress, planning, next steps). Don't run multiple topics together in a single paragraph.
- **Keep it concise.** Leadership skims — every sentence should earn its place. One strong sentence per person per theme beats three that say the same thing differently. If a point was made in the project section, don't repeat it in the per-person section. Cut filler like "continued to make progress on" — just say what happened.

## Step 4 — Present the draft

Write the draft to `tmp/cycle_updates/cycle_<recap>_<upcoming>_update.md` (e.g. `cycle_6_7_update.md`). Then ask:
- Does the tone feel right?
- Anything to add, remove, or reframe?
- Ready to post, or want adjustments?

Iterate on the file directly — don't copy-paste back and forth in chat.

Do NOT post to Slack. The user will do the final polish and post it themselves.
