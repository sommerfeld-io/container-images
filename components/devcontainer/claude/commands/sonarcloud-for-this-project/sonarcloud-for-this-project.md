---
argument-hint: [issues|hotspots|coverage|quality-gate|duplications|history|analyses|activity|files|rule <key>|overview]
---

# SonarCloud For This Project

Inspect the SonarCloud project bound to this git repository using the explicit API-calling scripts in `scripts/` (relative to this command file). These scripts already know how to authenticate and which project to target — do not write ad-hoc `curl` calls to the SonarCloud API and do not try to rediscover the connection details; always call the scripts.

## 0. Prerequisites

Run `bash scripts/quality-gate.sh --help` once (or any script with `--help`) only if you need to confirm the scripts directory path; otherwise skip straight to step 1.

The scripts read these environment variables, expected to already be set by `.devcontainer/devcontainer.json`:

- `SONARCLOUD_TOKEN`
- `SONARQUBE_URL`
- `SONARQUBE_ORGANIZATION`

If a script aborts with `[ERROR] Missing required environment variable(s): ...`, **stop immediately** and report that exact error to the user. Do not attempt to work around it, do not ask for a token in chat, and do not fall back to a different auth method — the user needs to fix their devcontainer environment.

If a script aborts with an HTTP 401/403 error, report it as-is and suggest the user check whether `SONARCLOUD_TOKEN` is valid and has access to the project. Do not retry with alternative auth schemes.

The project key is derived automatically from `SONARQUBE_ORGANIZATION` and the git `origin` remote (`<organization>_<repo-name>`, SonarCloud's default convention). If that is wrong for this repo, the user can override it by setting `SONARCLOUD_PROJECT_KEY`.

## 1. Interpret `$ARGUMENTS`

`$ARGUMENTS` tells you what to check. Match it (case-insensitively, loosely) against this table and run the corresponding script(s) from the `scripts/` directory next to this file:

| Argument                       | Checks                                                 | Script(s) to run                                                                                                                                                                               |
|--------------------------------|--------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `issues`                       | Bugs, vulnerabilities, code smells                     | `scripts/issues.sh`                                                                                                                                                                            |
| `hotspots` / `security`        | Security Hotspots                                      | `scripts/hotspots.sh`                                                                                                                                                                          |
| `coverage`                     | Test coverage                                          | `scripts/measures.sh --metrics coverage,uncovered_lines,uncovered_conditions,lines_to_cover`                                                                                                   |
| `quality-gate` / `gate`        | Quality Gate pass/fail and failed conditions           | `scripts/quality-gate.sh`                                                                                                                                                                      |
| `duplications`                 | Duplicated code                                        | `scripts/measures.sh --metrics duplicated_lines_density,duplicated_blocks,duplicated_files` (add `scripts/duplications.sh --file <fileKey>` for a specific file, found via `scripts/files.sh`) |
| `history` / `trend`            | How a metric evolved over time                         | `scripts/measures-history.sh`                                                                                                                                                                  |
| `analyses`                     | Analysis/version history and events                    | `scripts/analyses.sh`                                                                                                                                                                          |
| `activity` / `status`          | Whether the last background analysis succeeded         | `scripts/activity.sh`                                                                                                                                                                          |
| `files`                        | Browse the file tree / find a file key                 | `scripts/files.sh`                                                                                                                                                                             |
| `rule <ruleKey>`               | Full explanation of one rule (e.g. why an issue fired) | `scripts/rule.sh --key <ruleKey>`                                                                                                                                                              |
| `overview` / `all` / *(empty)* | Full picture of the project's health                   | `scripts/quality-gate.sh`, `scripts/measures.sh`, `scripts/issues.sh --limit 20`, `scripts/hotspots.sh --limit 20`, `scripts/activity.sh --limit 1`                                            |

Run every script from this directory, e.g.:

```bash
bash scripts/issues.sh --severities BLOCKER,CRITICAL --resolved false
```

Pass additional flags straight through when the user's request implies them (e.g. "show only blocker bugs" → `--types BUG --severities BLOCKER`). Run `<script> --help` if you're unsure which flags a script accepts — this is cheaper than guessing wrong and re-running.

## 2. Summarize the result for the user

Do not just dump raw JSON. For each script you ran, turn the output into a short, readable summary:

- **Quality Gate**: pass/fail, and list the failed conditions with their actual vs. threshold values.
- **Measures**: report the metrics as a compact list (e.g. `coverage: 42.3%`, `bugs: 3`), calling out anything that looks concerning (low coverage, non-A ratings, large tech debt).
- **Issues / Hotspots**: group by severity or vulnerability probability, show counts first, then list the most severe N (don't list all of them if there are many — mention the total and point to pagination via `--page`).
- **History/Analyses/Activity**: describe the trend or the latest status in prose, not just a table dump.

Always end with a one-line verdict (e.g. "Quality gate: FAILED — 2 new bugs and coverage below 80%.") so the user gets the headline even if they don't read the details.

If the SonarCloud project has no data for what was asked (e.g. no coverage report ever uploaded), say so plainly instead of implying an error occurred.
