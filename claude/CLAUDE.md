# Global Instructions

## Communication
- Be concise and direct. Skip unnecessary preamble.
- Don't apologize or use filler phrases.

## Coding
- Prefer simple, readable solutions over clever ones.
- Don't add comments that just restate the code.
- Don't refactor or "improve" code I didn't ask you to change.

## Git & Workflow
- Don't commit unless I ask you to. Always verify changes work before suggesting a commit.
- Don't push unless I ask you to.
- Use conventional commit format: `<type>(<scope>): <subject>`
- Always open PRs in draft status. I will manually mark as ready for review.
- Never post text visible to others (GitHub comments, PR reviews, issue comments, Linear updates, Slack messages, etc.) without showing me the exact draft text and getting explicit approval first.

## JavaScript
- Use `yarn` as package manager unless told otherwise.
- Use `nvm` — run `nvm use` to ensure correct Node version.
- Check `package.json` scripts to determine how to run tests (don't guess).

## Development Workflow
- TDD by default: write a failing test first, then implement to make it pass.
- Only skip TDD if explicitly told to.

## Tools & Environment
- macOS (Darwin)
- Default shell: zsh
