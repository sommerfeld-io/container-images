# Copilot Instructions

## Commit Messages: Conventional Commits

Always use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#summary) for every commit message.

**Format:** `<type>[optional scope]: <description>`

| Type | Effect | When to use |
|------|--------|-------------|
| `fix` | PATCH release | Patches a bug |
| `feat` | MINOR release | Introduces a new feature |
| `BREAKING CHANGE` footer | MAJOR release | Introduces a breaking API change |
| `build`, `chore`, `ci`, `docs`, `style`, `refactor`, `perf`, `test` | No release | All other changes |

**Rules:**
- A scope may be added in parentheses for extra context: `feat(parser): add ability to parse arrays`
- Breaking changes must include `BREAKING CHANGE:` in the footer: `feat!: drop support for Node 6`
- Commit message titles must also match the project pattern: `^(fix|feat|build|chore|ci|docs|style|refactor|perf|test)/[a-z0-9._-]+$`

## Build, test, and lint commands

This repository uses `task` plus `docker compose` as the canonical developer interface. `package.json` is only for release tooling and does not define the main build or test workflows.

Some CI jobs export `TASK_X_REMOTE_TASKFILES=1` before running `task` because `taskfile.yml` includes a shared remote taskfile from `sommerfeld-io/.github`. If local `task` runs complain about remote includes, export that variable first.

```bash
# full repo lint
task lint

# individual repo linters
docker compose up lint-yaml --exit-code-from lint-yaml
docker compose up lint-workflows --exit-code-from lint-workflows
docker compose up lint-filenames --exit-code-from lint-filenames
docker compose up lint-folders --exit-code-from lint-folders
docker compose up lint-markdown-links --exit-code-from lint-markdown-links

# Dockerfile lint for one image
docker compose up mkdocs-lint-dockerfile --exit-code-from mkdocs-lint-dockerfile

# build all images or one image
task build
task build:mkdocs

# validate InSpec profiles
task inspec:check
task inspec:check:devcontainer
task inspec:check:ftp-client

# run image tests (only devcontainer and ftp-client have InSpec test suites)
task test
task test:devcontainer
task test:ftp-client

# generate and preview docs
task docs:generate
task docs:run
docker compose up docs-build
```

## High-level architecture

- This repo is a collection of standalone container images, not a single application. Each image lives in `components/<image>/` with its own `Dockerfile` and README.
- `docker-compose.yml` is the local orchestration layer. It defines repo-level lint services, the docs builder/dev server, and one build target per image using tags like `local/<image>:${DEV_TAG}`.
- `taskfile.yml` is the top-level workflow entry point. It fans out over shared image/profile lists for linting, building, testing, cleanup, and docs generation.
- Tests live under `tests/inspec/<image>/`. Only `devcontainer` and `ftp-client` currently have InSpec profiles, so they are the only images exercised by `task test` and the post-build CI test stage.
- The documentation flow is generated rather than hand-maintained in every location:
  - `docs/index.md` is copied to `README.md`
  - `docs/license.md` is copied to `LICENSE.md`
  - each `components/<image>/README.md` is copied into `docs/container-images/<image>.md`
  - the docs site is built into `target/docs/site`
- CI mirrors the same structure: lint repo files, lint Dockerfiles, validate InSpec profiles, build SHA-tagged images, run InSpec against the tested images, promote successful images to the edge tag on `main`, regenerate docs, then the release workflow retags edge images to version and `latest`.

## Key conventions

- Treat `docs/index.md`, `docs/license.md`, and `components/*/README.md` as the source docs. `README.md`, `LICENSE.md`, and `docs/container-images/*` are generated outputs.
- Component README files serve two downstream consumers: they become docs pages during `task docs:generate`, and they are pushed to Docker Hub as the image descriptions in the release workflow.
- When adding, renaming, or removing an image, keep the shared image lists in sync across `taskfile.yml`, `docker-compose.yml`, workflow matrices in `.github/workflows/`, and `mkdocs.yml` navigation/docs generation.
- The testable image list is separate from the buildable image list. If a new image should be covered by InSpec, add both the profile under `tests/inspec/<image>/` and the relevant profile/image matrices in Task and GitHub Actions.
- Directory structure and filenames are enforced. New paths may require updates to `.folderslintrc`, and filenames must follow `.ls-lint.yml` conventions, including kebab-case for `.instructions.md` files.
- Pre-commit is wired to run the repo linter stack via `task lint`, plus shell formatting with `shfmt`.
