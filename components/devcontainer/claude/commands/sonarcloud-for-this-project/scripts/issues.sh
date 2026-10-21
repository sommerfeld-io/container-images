#!/usr/bin/env bash
# Search issues (bugs, vulnerabilities, code smells) for the current project.
# API: GET /api/issues/search
#
# Usage: issues.sh [--types BUG,VULNERABILITY,CODE_SMELL] [--severities BLOCKER,CRITICAL,...]
#                   [--statuses OPEN,CONFIRMED,...] [--resolved false] [--limit 50] [--page 1] [--raw]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

types=""
severities=""
statuses=""
resolved="false"
limit="50"
page="1"
raw=false

while [[ $# -gt 0 ]]; do
  case "$1" in
  --types)
    types="$2"
    shift 2
    ;;
  --severities)
    severities="$2"
    shift 2
    ;;
  --statuses)
    statuses="$2"
    shift 2
    ;;
  --resolved)
    resolved="$2"
    shift 2
    ;;
  --limit)
    limit="$2"
    shift 2
    ;;
  --page)
    page="$2"
    shift 2
    ;;
  --raw)
    raw=true
    shift
    ;;
  -h | --help)
    echo "Usage: $(basename "$0") [--types BUG,VULNERABILITY,CODE_SMELL] [--severities BLOCKER,CRITICAL,MAJOR,MINOR,INFO] [--statuses OPEN,CONFIRMED,REOPENED,RESOLVED,CLOSED] [--resolved false] [--limit 50] [--page 1] [--raw]"
    exit 0
    ;;
  *) sonar::usage_and_exit "Unknown argument: $1" ;;
  esac
done

project_key="$(sonar::project_key)"
args=(
  --data-urlencode "componentKeys=${project_key}"
  --data-urlencode "organization=${SONARQUBE_ORGANIZATION}"
  --data-urlencode "resolved=${resolved}"
  --data-urlencode "ps=${limit}"
  --data-urlencode "p=${page}"
)
[[ -n "${types}" ]] && args+=(--data-urlencode "types=${types}")
[[ -n "${severities}" ]] && args+=(--data-urlencode "severities=${severities}")
[[ -n "${statuses}" ]] && args+=(--data-urlencode "statuses=${statuses}")

response="$(sonar::api "/api/issues/search" "${args[@]}")"

if [[ "${raw}" == true ]]; then
  echo "${response}" | jq .
else
  echo "${response}" | jq '{
        total: .total,
        paging: .paging,
        issues: [.issues[] | {
            key, rule, type, severity, status,
            component, line, message,
            tags, effort, creationDate
        }]
    }'
fi
