---
allowed-tools: Bash, Read, mcp__linear-server__get_issue
description: Open or update a draft PR for the current branch, idempotently. Pre-fills body from the linked Linear ticket and the repo's PR template. Safe to re-run as work evolves.
---

# Submit PR

Submit the current branch as a **draft** PR for review. Idempotent — creates the PR if it doesn't exist, updates the body (and title only when stale) if it does.

## Input

`$ARGUMENTS` — optional Linear ticket ID. If absent, infer from the branch name (e.g. `cor-465` → `COR-465`). If neither is available, stop and tell the user.

## Preconditions

- Current branch isn't `main`.
- Branch has at least one commit ahead of `main`.
- Repo has `.github/PULL_REQUEST_TEMPLATE.md`.

If any precondition fails, stop and report — don't try to fix.

## Flow

1. **Resolve ticket.** From `$ARGUMENTS` or the branch name. Fetch the ticket via Linear MCP.

2. **Push the branch.** If unpushed: `git push -u origin <branch>`.

   If push is rejected because the remote is ahead, inspect the divergent commits first:
   - **If all divergent commits are from `github-actions[bot]`** (the PR template substitution action committing a placeholder replacement): `git pull --rebase`, then push.
   - **Otherwise** (a real divergence — teammate pushed, or unexpected state): stop and surface to the user. Don't auto-rebase past commits that aren't the bot's.

   **Never force push.** If the rebase has conflicts, stop and surface — don't resolve silently.

3. **Detect existing PR.** `gh pr view --json number,title,body,isDraft`.

4. **Generate body** from scratch (see [Body generation](#body-generation)). The skill owns the body — manual edits will be overwritten.

5. **Generate title** (see [Title generation](#title-generation)). Only update the existing title if it's clearly stale (doesn't match the diff) or non-conformant (not conventional-commits format). Otherwise leave it.

6. **Create or update.**
   - No PR → `gh pr create --draft --title "$TITLE" --body "$BODY"`
   - PR exists → `gh pr edit <number> --body "$BODY"`, plus `--title "$TITLE"` only if step 5 decided to change it.

7. **Report** the PR URL.

## Body generation

Read `.github/PULL_REQUEST_TEMPLATE.md`. Use its structure verbatim — section names evolve; don't hardcode them.

For each section in the template:

- **Top-of-body link** (`[$ISSUE_ID](...)` or similar): leave the `$ISSUE_ID` and any other `$PLACEHOLDER` tokens verbatim. The GitHub Action substitutes them on PR open/edit. Don't pre-fill them.

- **Overview**: 2–4 sentences synthesized from the ticket's Problem + Solution (or equivalent narrative). Explain *why* this work matters, not *what* changed.

- **Changes**: behavior-relevant changes from the diff. Bulleted; each bullet is one product-visible change. **Skip test-only changes** — those belong in Testing per the template's annotation.

- **Testing**: automated test changes added or updated. If none, write `Manual only — see Quality Assurance` and briefly explain why (e.g. "justfile recipes aren't test-covered in this repo").

- **Quality Assurance**: convert the ticket's acceptance criteria into unchecked checkboxes — one `- [ ]` per AC bullet. Preserve wording where it works as a QA check; tighten if it doesn't.

- **Documentation**: leave the default `- [ ] Repo docs are up to date` unchecked unless the PR explicitly updates docs (in which case check it).

- Any other section the template defines: fill with a single dash `-` placeholder, or honest `N/A — <reason>` if it clearly doesn't apply.

## Title generation

Format: `<type>(<scope>): <subject>` (conventional commits).

- **Start from the ticket title.** Rewrite to describe what the PR *actually changes*, not what the ticket *aspires to*. The PR title becomes a git log entry — make it scannable for someone six months from now.
- **Type**: infer from the diff. `feat` new behavior, `fix` bug fix, `docs` docs-only, `chore` config/tooling, `refactor` no behavior change, `test` test-only.
- **Scope**: optional. Sample `git log --oneline -50` to match the scopes the repo uses.
- **Subject**: imperative mood, lowercase, no trailing period. Under ~70 chars total.

## Out of scope

- Marking the PR ready for review (always draft — user does that manually).
- Force pushing.
- Merging.
- Posting comments. PR body and title only.
- Verifying the work compiles/tests/lints. The caller is responsible for that.
