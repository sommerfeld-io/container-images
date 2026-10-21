#!/usr/bin/env bash
# Show background task (Compute Engine) activity: did the last analysis
# succeed, fail, or is one still running?
# API: GET /api/ce/activity
#
# Usage: activity.sh [--limit 10] [--raw]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# common.sh is resolved at runtime via SCRIPT_DIR; it is only followed when shellcheck runs with -x
# shellcheck source=../lib/common.sh disable=SC1091
source "${SCRIPT_DIR}/../lib/common.sh"

limit="10"
raw=false

while [[ $# -gt 0 ]]; do
  case "$1" in
  --limit)
    limit="$2"
    shift 2
    ;;
  --raw)
    raw=true
    shift
    ;;
  -h | --help)
    echo "Usage: $(basename "$0") [--limit 10] [--raw]"
    exit 0
    ;;
  *) sonar::usage_and_exit "Unknown argument: $1" ;;
  esac
done

project_key="$(sonar::project_key)"
response="$(sonar::api "/api/ce/activity" \
  --data-urlencode "component=${project_key}" \
  --data-urlencode "ps=${limit}")"

if [[ "${raw}" == true ]]; then
  echo "${response}" | jq .
else
  echo "${response}" | jq '[.tasks[] | {
        id, type, status, componentName,
        submittedAt, startedAt, executedAt,
        errorMessage
    }]'
fi
