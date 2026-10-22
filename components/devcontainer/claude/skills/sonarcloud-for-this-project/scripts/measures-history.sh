#!/usr/bin/env bash
# Show the trend of one or more metrics over time (e.g. is coverage going up or down?).
# API: GET /api/measures/search_history
#
# Usage: measures-history.sh [--metrics coverage,bugs,...] [--from YYYY-MM-DD] [--to YYYY-MM-DD] [--raw]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# common.sh is resolved at runtime via SCRIPT_DIR; it is only followed when shellcheck runs with -x
# shellcheck source=../lib/common.sh disable=SC1091
source "${SCRIPT_DIR}/../lib/common.sh"

default_metrics="coverage,duplicated_lines_density,bugs,vulnerabilities,code_smells,ncloc"
metrics="${default_metrics}"
from=""
to=""
raw=false

while [[ $# -gt 0 ]]; do
  case "$1" in
  --metrics)
    metrics="$2"
    shift 2
    ;;
  --from)
    from="$2"
    shift 2
    ;;
  --to)
    to="$2"
    shift 2
    ;;
  --raw)
    raw=true
    shift
    ;;
  -h | --help)
    echo "Usage: $(basename "$0") [--metrics coverage,bugs,...] [--from YYYY-MM-DD] [--to YYYY-MM-DD] [--raw]"
    echo "Default metrics: ${default_metrics}"
    exit 0
    ;;
  *) sonar::usage_and_exit "Unknown argument: $1" ;;
  esac
done

project_key="$(sonar::project_key)"
args=(
  --data-urlencode "component=${project_key}"
  --data-urlencode "metrics=${metrics}"
)
[[ -n "${from}" ]] && args+=(--data-urlencode "from=${from}")
[[ -n "${to}" ]] && args+=(--data-urlencode "to=${to}")

response="$(sonar::api "/api/measures/search_history" "${args[@]}")"

if [[ "${raw}" == true ]]; then
  echo "${response}" | jq .
else
  echo "${response}" | jq '.measures | map({metric, history})'
fi
