---
allowed-tools: Bash, Read, Edit, Write, Grep, Glob, Skill, Agent, mcp__linear-server__get_issue
description: Work a Linear ticket end-to-end. Read the ticket, align on acceptance criteria with the user, create a stack, execute, self-review, and leave a draft PR ready for human review.
---

# Do ticket

Take a Linear ticket from "assigned" to "draft PR ready for review." Front-load alignment with the user; execute autonomously after that.

## Input

`$ARGUMENTS` — Linear ticket ID (e.g. `COR-465`). Required. If absent, stop and ask the user for one.

## Flow

### Phase 1 — Alignment (front-loaded, with the user)

1. **Fetch ticket** via `mcp__linear-server__get_issue`. Read Problem / Solution / AC / Implementation Suggestions / any other sections.

2. **Confirm AC clarity.** AC is intentionally high-level and outcome-focused — don't push for implementation specifics. The question is: *is the outcome clear enough to verify?*
   - If yes, proceed.
   - If no (vague outcome, missing AC entirely, ambiguous about what "done" looks like): ask the user clarifying questions to sharpen the outcome. Don't suggest implementation-flavored AC.

3. **Plan AC verification.** Share a plan in chat with three parts:
   - **(a) Approach** — what files/packages change, the rough strategy.
   - **(b) Verification** — how you'll verify *each* AC item. Tests, commands to run, manual checks (and acknowledge if a check is genuinely manual / browser-based / not something the agent can do alone).
   - **(c) Out of scope** — explicitly name what you'll *not* touch.

4. **Wait for explicit go-ahead.** Don't start editing until the user says go.

### Phase 2 — Execution (autonomous)

5. **Create the stack.** `just stack <ticket-id>`. Work happens inside `stacks/<ticket>/...`.

6. **Execute locally.** Implement the changes. Commit liberally on the local branch — checkpoint commits are fine; stacks are isolated. Conventional commits format. **Don't push or open the PR yet** — there's no value in eager CI runs on incomplete work.

7. **Push + open PR + verify, in parallel.** Once the work feels potentially done:
   - Push the branch.
   - Invoke `/submit-pr` to open the draft PR. CI starts running in the background.
   - Run the AC verification steps from your plan *while* CI runs. The parallelism is the point — by the time local AC verification is done, CI should be too.

8. **Iterate.** If AC verification or CI surfaces issues:
   - Implement fixes. Commit, push.
   - Re-run any AC verification affected by the change.
   - Watch CI on subsequent pushes.
   - Continue until all AC items pass and all checks are green.

   Bias to action throughout. Don't pause to re-confirm with the user for things inside the plan. If you hit something genuinely outside the plan, see [Failure modes](#failure-modes).

### Phase 3 — Self-review (autonomous)

8. **Refresh the PR body.** Invoke `/submit-pr` again — its idempotent rerun regenerates the body and QA checkboxes to reflect the work as shipped.

9. **Subagent review.** Spawn a subagent via the Agent tool to run `/review-pr` on the PR. The subagent posts a PENDING review with inline findings and a verdict.

10. **Act on the review.** Read the PENDING review.
    - **Blockers** — fix and commit.
    - **Suggestions** — judgment call per `~/.claude/CLAUDE.md` engineering taste: in-scope polish → do it; tangent → skip and note in the final report.
    - **Nits** — usually skip; act only if the call clearly helps.
    - **Disagreement on a blocker** — if you genuinely think the subagent is wrong: don't make the change. Instead, post a comment on the PR explaining the disagreement and current state, so the user can override on review. (This is allowed without draft-approval — it's a comment on your own PR.)

11. **Re-review loop.** After acting on feedback, re-run `/review-pr` in a fresh subagent. Repeat until:
    - Subagent verdict is Approve (no remaining blockers), AND
    - No in-scope suggestions remain that you'd want to act on, AND
    - You haven't introduced any new disagreements you haven't documented.

### Phase 4 — Final sweep + handoff

12. **Refresh PR body one more time** via `/submit-pr` so it reflects the final state, including any review-driven changes.

13. **Confirm all CI checks green.** Fix anything broken by this PR's changes, including flakes in tests this PR introduced or touched. **Pre-existing flakes or unrelated infra failures are out of scope** — surface them in the final report, don't try to fix them as part of this ticket.

14. **Ping the user.** Brief text message:
    - PR URL
    - Verdict from final self-review
    - Anything skipped intentionally (tangents) with a one-line note each
    - Anything flagged for the user to decide (disagreements, manual verifications you couldn't do alone)

## Failure modes

These pause execution and require the user:

- **AC turns out to be wrong.** During execution you discover the AC was based on a misunderstanding of the codebase. Stop, explain, and replan with the user. Don't proceed with the wrong AC.
- **Approach hits a dead end.** The planned approach can't work for reasons we couldn't have anticipated. Stop, share what you learned, and discuss alternatives.
- **A CI check fails in a way that's outside this PR's scope** (pre-existing flake, unrelated infra breakage, failure in code this PR didn't touch). Surface it; don't try to fix it here.
- **The subagent and you disagree on a blocker and you're uncertain.** Better to ask than to ship the wrong call.

In all other cases — minor judgment calls inside the plan — keep going.

## Out of scope

- Marking the PR ready for review. Always draft. The user manually marks ready.
- Merging. Never.
- Posting comments addressed to other people (replies to other reviewers, comments on unrelated tickets, etc.) without the user's draft-first approval.
- Status updates / comments on the Linear ticket itself unless the user asks.
