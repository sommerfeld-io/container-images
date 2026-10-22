#!/usr/bin/env bash
# Show the Quality Gate status of the current project.
# API: GET /api/qualitygates/project_status
#
# Usage: quality-gate.sh [--raw]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# common.sh is resolved at runtime via SCRIPT_DIR; it is only followed when shellcheck runs with -x
# shellcheck source=../lib/common.sh disable=SC1091
source "${SCRIPT_DIR}/../lib/common.sh"

raw=false
for arg in "$@"; do
  case "${arg}" in
  --raw) raw=true ;;
  -h | --help)
    echo "Usage: $(basename "$0") [--raw]"
    exit 0
    ;;
  *) sonar::usage_and_exit "Unknown argument: ${arg}" ;;
  esac
done

project_key="$(sonar::project_key)"
response="$(sonar::api "/api/qualitygates/project_status" \
  --data-urlencode "projectKey=${project_key}")"

if [[ "${raw}" == true ]]; then
  echo "${response}" | jq .
else
  echo "${response}" | jq '{
        projectKey: "'"${project_key}"'",
        status: .projectStatus.status,
        failedConditions: [
            .projectStatus.conditions[]
            | select(.status == "ERROR")
            | {metric: .metricKey, comparator, errorThreshold, actualValue: .actualValue}
        ]
    }'
fi
