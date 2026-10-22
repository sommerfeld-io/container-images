#!/usr/bin/env bash
# Show current project-level measures: coverage, duplications, size, ratings, ...
# API: GET /api/measures/component
#
# Usage: measures.sh [--metrics key1,key2,...] [--raw]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# common.sh is resolved at runtime via SCRIPT_DIR; it is only followed when shellcheck runs with -x
# shellcheck source=../lib/common.sh disable=SC1091
source "${SCRIPT_DIR}/../lib/common.sh"

default_metrics="alert_status,bugs,vulnerabilities,code_smells,security_hotspots,coverage,duplicated_lines_density,ncloc,reliability_rating,security_rating,sqale_rating,sqale_index"
metrics="${default_metrics}"
raw=false

while [[ $# -gt 0 ]]; do
  case "$1" in
  --metrics)
    metrics="$2"
    shift 2
    ;;
  --raw)
    raw=true
    shift
    ;;
  -h | --help)
    echo "Usage: $(basename "$0") [--metrics key1,key2,...] [--raw]"
    echo "Default metrics: ${default_metrics}"
    exit 0
    ;;
  *) sonar::usage_and_exit "Unknown argument: $1" ;;
  esac
done

project_key="$(sonar::project_key)"
response="$(sonar::api "/api/measures/component" \
  --data-urlencode "component=${project_key}" \
  --data-urlencode "metricKeys=${metrics}")"

if [[ "${raw}" == true ]]; then
  echo "${response}" | jq .
else
  echo "${response}" | jq '.component.measures | map({(.metric): .value}) | add'
fi
