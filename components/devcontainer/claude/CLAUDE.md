# Development Environment

## Commit Messages: Conventional Commits

Always use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#summary) for every commit message.

**Format:** `<type>(optional scope): <description>`

| Type                                                                | Effect        | When to use                      |
|---------------------------------------------------------------------|---------------|----------------------------------|
| `fix`                                                               | PATCH release | Patches a bug                    |
| `feat`                                                              | MINOR release | Introduces a new feature         |
| `BREAKING CHANGE` footer                                            | MAJOR release | Introduces a breaking API change |
| `build`, `chore`, `ci`, `docs`, `style`, `refactor`, `perf`, `test` | No release    | All other changes                |

**Rules:**

- A scope may be added in parentheses for extra context: `feat(parser): add ability to parse arrays`. A scope may not be with a slash (`/`).
- Breaking changes must include `BREAKING CHANGE:` in the footer: `feat: drop support for Node 6`
- Commit message titles must also match the project pattern: `^(fix|feat|build|chore|ci|docs|style|refactor|perf|test)/[a-z0-9._-]+$`

Write commit messages using the Conventional Commits format, ensuring the header (`type(scope): summary`) is clear and descriptive, as it will be displayed on GitHub release pages and used for changelogs. Focus the header on user-visible, meaningful change descriptions and avoid vague wording. Always document breaking changes explicitly in the footer using `BREAKING CHANGE:` (do not use the `!` notation).

## Markdown style

Any markdown you generate must comply with the project's markdownlint rules:

- **MD004** - use a consistent list marker style throughout each document
- **MD007** - indent nested lists with 4 spaces
- **MD013** - line length is not enforced (disabled)
- **MD035** - use `---` for horizontal rules
- **MD046** - use fenced code blocks (``` ... ```) rather than indented code blocks

### Markdown tables

Pad all columns so every cell in a column is the same width. The separator row must match:

```markdown
| Key         | Value         |
|-------------|---------------|
| Some key    | Some value    |
| Another key | Another value |
```

Not:

```markdown
| Key | Value |
|-----|-------|
| Some key | Some value |
| Another key | Another value |
```
