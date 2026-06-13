---
model: claude-haiku-4-5-20251001
---

# Create or Update Pull Request

Analyze all changes on the current branch compared to the main branch, write a pull request description, then create or update a GitHub pull request using the GitHub CLI (`gh`).

## Steps

### 1. Check the current branch

Run `git rev-parse --abbrev-ref HEAD` to get the current branch name.

If the branch is `main`, `master`, or `beta`, stop immediately and tell the user: "PRs are not created for protected branches (main, master, beta)."

### 2. Verify GitHub CLI authentication

Run `gh auth status` to check if the user is authenticated.

If authentication is missing or expired, stop and tell the user: "You are not authenticated with the GitHub CLI. Please run `gh auth login` before proceeding."

### 3. Determine the GitHub repository

Run `git remote get-url origin` to get the remote URL.

Parse the repository in `OWNER/REPO` format:

- SSH format: `git@github.com:OWNER/REPO.git` → `OWNER/REPO`
- HTTPS format: `https://github.com/OWNER/REPO.git` → `OWNER/REPO`

### 4. Collect git information

Run these commands:

- `git log main...HEAD --oneline` - commits on this branch
- `git diff main...HEAD --stat` - summary of changed files
- `git diff main...HEAD` - actual code changes

### 5. Generate the PR description

Write the PR description in this exact structure:

```markdown
<type>(optional scope): <concise description of what this PR does, not how>

Two to four sentences. Explain what this PR is about and why it exists. Write for a developer or platform engineer audience but avoid unnecessary jargon — assume the reader has not looked at the diff yet. Focus on intent and impact, not implementation detail. Do not add a headline before this paragraph; the PR title is the main headline.

### Changes

A bullet list of logical change groups. Do not list commits one-to-one. Group related changes and describe what they achieve. Aim for 3–7 bullets. Each bullet should complete the sentence "This PR ...".

### Benefits

Two to five bullet points on what improves after this PR is merged. Think: what is easier, faster, more reliable, or less manual? Keep it concrete but not overly technical.
```

The **first line** of the generated description is the PR title. The **remaining content** (everything after the title line) is the PR description body.

The PR body must be well-formatted Markdown with real line breaks and spacing so that GitHub renders it correctly. Do not produce the body as a single quoted string with escaped `\n` characters.

#### Title format rules (Conventional Commits)

The title must follow `<type>(optional scope): <description>` where type is one of:

| Type | Semver effect | When to use |
|------|--------------|-------------|
| `feat` | MINOR | Introduces a new feature |
| `fix` | PATCH | Patches a bug |
| `build`, `chore`, `ci`, `docs`, `style`, `refactor`, `perf`, `test` | none | All other changes |

- The scope, if used, must not contain a slash (`/`).
- Breaking changes must **not** use the `!` notation. Instead, add `BREAKING CHANGE: <explanation>` as the last line of the description body.
- The description must be clear and user-visible — it will appear in changelogs and release pages. Avoid vague wording.
- Do not add a period at the end of the title.

### 6. Check for an existing open PR on this branch

Run:

```bash
gh pr list --head BRANCH_NAME --state open --json number,url
```

Replace `BRANCH_NAME` with the current branch name.

- If the output is an **empty array** (`[]`): proceed to step 7 (create).
- If the output contains **one or more PRs**: take the first result, extract its `number`, and proceed to step 8 (update).

Ignore all closed PRs (merged or unmerged); only open PRs count.

### 7. Create a new PR

Run:

```bash
gh pr create \
  --base main \
  --head BRANCH_NAME \
  --title "PR_TITLE" \
  --body "PR_DESCRIPTION_BODY" \
  --assignee "@me"
```

Replace all placeholders with actual values. The `--body` value must be valid Markdown with real newlines, not escaped `\n` sequences.

### 8. Update an existing PR

Run:

```bash
gh pr edit PR_NUMBER \
  --title "PR_TITLE" \
  --body "PR_DESCRIPTION_BODY"
```

Replace all placeholders with actual values.

### 9. Report the result

After creating or updating the PR, end your response with:

```plain
PR: <url>
```

where `<url>` is the GitHub URL of the pull request. This must always be the last line of your response.

## Tone and style

- Audience: developers, platform engineers, tech leads
- Not too technical — skip implementation minutiae, focus on outcomes
- Active voice, present tense
- No filler phrases like "This PR aims to..." or "In this change we..."
- Do not mention commit hashes or branch names
- The title must always start with a Conventional Commits type prefix — never a bare sentence
- Do not link issues in the PR body
- The summary paragraph must not have a headline; the PR title is the main headline
