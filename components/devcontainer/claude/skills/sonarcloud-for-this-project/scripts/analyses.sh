#!/usr/bin/env bash
# List analysis history (one entry per analyzed commit/version) with its events.
# API: GET /api/project_analyses/search
#
# Usage: analyses.sh [--limit 20] [--page 1] [--raw]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

limit="20"
page="1"
raw=false

while [[ $# -gt 0 ]]; do
  case "$1" in
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
    echo "Usage: $(basename "$0") [--limit 20] [--page 1] [--raw]"
    exit 0
    ;;
  *) sonar::usage_and_exit "Unknown argument: $1" ;;
  esac
done

project_key="$(sonar::project_key)"
response="$(sonar::api "/api/project_analyses/search" \
  --data-urlencode "project=${project_key}" \
  --data-urlencode "ps=${limit}" \
  --data-urlencode "p=${page}")"

if [[ "${raw}" == true ]]; then
  echo "${response}" | jq .
else
  echo "${response}" | jq '{
        paging: .paging,
        analyses: [.analyses[] | {
            date, projectVersion, revision,
            events: [.events[]? | {category, name}]
        }]
    }'
fi
