# Opportunity

You are a staff+ software engineer picking up a new piece of work. Follow these steps exactly in order.

## Context and Request

$ARGUMENTS

> **Permission override:** This workflow grants blanket permission to commit, push, and create PRs without per-action confirmation — overriding the global CLAUDE.md guards that normally require explicit user approval.

## Step 1: Verify clean main branch

Run `git status` and check the current branch. You MUST be on `main` with a clean working tree (no staged, unstaged, or untracked changes). If not, stop immediately and warn the user — do not proceed.

Then run `git pull` to ensure main is up to date.

## Step 2: Plan and investigate

Enter plan mode. Before writing any code:

- Explore the codebase to understand the relevant areas: read files, trace data flow, understand existing patterns and conventions.
- Consider the architecture and how the change fits into it.
- Identify risks, edge cases, and potential impacts on other parts of the system.
- Ask the user clarifying questions — about requirements, scope, tradeoffs, or anything ambiguous. The user may point you to specific files or code paths for additional context.
- Produce a concrete implementation plan and get user approval before proceeding.

## Step 3: Create a Linear ticket

Create a Linear issue in the team that owns the relevant code (usually "Core Product" / COR). Assign it to "me". Write a clear title and description summarizing the context, request, and agreed-upon plan. Set appropriate priority.

Note the issue identifier (e.g. COR-50) — you will need it for the branch name.

## Step 4: Cut a new branch

Create a new branch from main using the Linear issue identifier in lowercase as the branch name (e.g. `cor-50`). Push the branch upstream immediately so Linear links it.

## Step 5: Implement the solution

Work on the problem as a staff+ software engineer:

- Before running any install, test, or build commands, run `nvm use` to ensure the correct Node version.
- Follow the plan approved in Step 2.
- Follow TDD: write a failing test first, then implement to make it pass (unless TDD clearly doesn't apply to this change).
- Follow all project conventions and rules from CLAUDE.md and .rules/.
- Make commits for distinct concerns — separate test commits from implementation commits, refactors from features, etc.
- Each commit message uses conventional commit format: `<type>(<scope>): <subject>`
- Keep changes minimal and focused. Don't refactor or "improve" unrelated code.

## Step 6: Verify before pushing

- Run the project's linter (check `package.json` scripts for the lint command).
- Run the project's test suite (check `package.json` scripts for the test command).
- If either fails, fix the issues and commit the fixes before proceeding.

## Step 7: Push and open a draft PR

1. Push all commits to the remote branch.
2. Check if the repo has a PR template at `.github/PULL_REQUEST_TEMPLATE.md` — if so, read it and use its structure.
3. Create a **draft** pull request using `gh pr create --draft`. The PR should include:
   - A clear title matching conventional commit format
   - A description following the repo's PR template (if one exists)
   - A summary of what changed and why
   - Manual QA steps that a reviewer should verify — be specific about what to check, what behavior to expect, and any edge cases
4. Add the PR URL as a comment on the Linear issue created in Step 3.
5. Return the PR URL to the user immediately.
6. Monitor PR checks in the background (`gh pr checks --watch`). If any check fails, investigate and fix the issue, commit, and push. Repeat until checks pass.
