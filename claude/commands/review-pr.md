---
allowed-tools: Bash, Read, Grep, Glob, mcp__linear-server__get_issue
description: Review a PR thoroughly and post findings as a PENDING review (never submits). Use before merging your own PR, or to get a second opinion on someone else's.
---

# Review PR

Review a PR as a thoughtful senior engineer would. Post findings as a **PENDING** review for the human reviewer to decide what to submit. **Never submit** the review.

## Input

`$ARGUMENTS` — optional PR number. If absent, use the current branch's PR (`gh pr view --json number`).

## Preconditions

- A PR exists for the target.

If not, stop and report — don't try to open one.

## Flow

1. **Fetch PR data.** Title, body, diff (`gh pr diff`), commits, CI status, existing reviews, linked Linear ticket (parse from body or branch name).

2. **Load conventions.** Read these if they exist:
   - Repo's `CLAUDE.md` (root and any package-level)
   - Repo's `.rules/*.md`
   - Repo's `.github/PULL_REQUEST_TEMPLATE.md`
   - Linked Linear ticket's acceptance criteria

3. **Review the diff** against four lenses, in priority order:

   **a. Acceptance criteria fulfillment.** Does the diff deliver what the ticket promised? Anything missing? Anything that goes past the AC? This is the most important lens.

   **b. Engineering taste** (per `~/.claude/CLAUDE.md`).
   - Painting into corners: are we taking shortcuts that'll force expensive rework?
   - Things to cut: any code that could be smaller, simpler, or removed entirely?
   - Polish that was deferred and shouldn't have been (in-scope edge cases, half-finished paths).

   **c. Correctness.** Bugs, broken edge cases, regressions, race conditions, error handling gaps.

   **d. Conventions.** Matches the codebase's patterns, `.rules/` content, naming, structure. Skip anything that's just personal style.

4. **Triage each finding** into one of three severities:
   - **Blocker** — must be addressed before merge (correctness bug, AC not met, painting into a corner).
   - **Suggestion** — would meaningfully improve the PR but isn't a merge blocker.
   - **Nit** — minor / optional. Use sparingly; only when the call really helps.

5. **Handle any existing PENDING review from the agent.** GitHub doesn't allow adding comments to an existing PENDING review — the same author can only hold one PENDING review at a time. So:
   - List PENDING reviews on the PR: `gh api repos/<owner>/<repo>/pulls/<N>/reviews --jq '.[] | select(.state == "PENDING")'`.
   - Filter to those authored by the agent's GitHub identity (`gh api user --jq .login`).
   - If one exists: fetch its comments via `gh api repos/<owner>/<repo>/pulls/<N>/reviews/<review_id>/comments`, then delete the review via `gh api -X DELETE repos/<owner>/<repo>/pulls/<N>/reviews/<review_id>`.
   - **Preserve those comments verbatim** — the user may have edited or removed some during curation. Carry forward whatever remained.

6. **Post as a single PENDING review.**
   - Build the `comments` array from: (a) the carried-over comments from step 5 (verbatim — path, line, body), then (b) new findings from this run. Don't try to dedupe; surface both and let the user reconcile on submit.
   - Top-level body: short summary (2–4 lines) + verdict (`Approve` / `Request changes` / `Comment`) + counts (e.g. `3 blockers, 2 suggestions`). Note in the body if any comments were carried over from a prior pending review.
   - **Omit the `event` field** so the review stays PENDING.
   - POST in one call (see [GitHub API notes](#notes-on-the-github-api) for syntax).

7. **Report to chat.** Brief: PR number, verdict, finding counts, whether any prior comments were carried over, link to the PR's Files Changed tab. Don't restate every finding.

## Verdict criteria

- **Approve** — no blockers, suggestions are optional.
- **Request changes** — at least one blocker.
- **Comment** — no blockers but enough context worth flagging (e.g. you noticed an out-of-scope opportunity but the PR itself is fine).

## What this skill won't do

- **Submit** the review. Always PENDING. Use `event: null` (or omit `event`) on the API call — never `APPROVE` / `REQUEST_CHANGES` / `COMMENT` as the submitted event. (PENDING reviews are only visible to the reviewer, so they don't count as "messages addressed to another person" — fine to post directly on any PR.)
- Re-review unchanged code blindly. The skill replaces any prior PENDING review from the agent, but carries over its existing comments — see step 5.
- Apply nits aggressively. Real value is in blockers and meaningful suggestions.

## Notes on the GitHub API

To post a PENDING review with inline comments in one call, send a JSON payload via stdin. `gh api`'s `-F`/`-f` flat-form flags can't build the nested `comments` array the `/reviews` endpoint requires; piping JSON is the working approach.

```bash
# Build the payload with jq (or a heredoc) and pipe to gh api.
jq -n \
  --arg body "$REVIEW_BODY" \
  --argjson comments "$COMMENTS_JSON" \
  '{body: $body, comments: $comments}' \
| gh api repos/<owner>/<repo>/pulls/<N>/reviews \
    -X POST \
    --input -
```

Where `$COMMENTS_JSON` is a JSON array like:
```json
[
  {"path": "src/foo.ts", "line": 42, "body": "Blocker: this swallows the error silently."},
  {"path": "src/bar.ts", "line": 17, "body": "Suggestion: extract to a helper for clarity."}
]
```

**Critical:** omit the `event` field entirely. Setting `event: "APPROVE" | "REQUEST_CHANGES" | "COMMENT"` submits the review. Omitting it (or `null`) keeps it PENDING.

Verify with: `gh api repos/<owner>/<repo>/pulls/<N>/reviews --jq '.[] | select(.state == "PENDING")'`.
