#!/usr/bin/env bash
# Browse the project's file tree and find file keys (needed by duplications.sh,
# and useful to scope issues.sh/hotspots.sh to a single file or directory).
# API: GET /api/components/tree
#
# Usage: files.sh [--query <search-term>] [--qualifiers FIL|DIR] [--limit 100] [--raw]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# common.sh is resolved at runtime via SCRIPT_DIR; it is only followed when shellcheck runs with -x
# shellcheck source=../lib/common.sh disable=SC1091
source "${SCRIPT_DIR}/../lib/common.sh"

query=""
qualifiers="FIL"
limit="100"
raw=false

while [[ $# -gt 0 ]]; do
  case "$1" in
  --query)
    query="$2"
    shift 2
    ;;
  --qualifiers)
    qualifiers="$2"
    shift 2
    ;;
  --limit)
    limit="$2"
    shift 2
    ;;
  --raw)
    raw=true
    shift
    ;;
  -h | --help)
    echo "Usage: $(basename "$0") [--query <search-term>] [--qualifiers FIL|DIR] [--limit 100] [--raw]"
    exit 0
    ;;
  *) sonar::usage_and_exit "Unknown argument: $1" ;;
  esac
done

project_key="$(sonar::project_key)"
args=(
  --data-urlencode "component=${project_key}"
  --data-urlencode "qualifiers=${qualifiers}"
  --data-urlencode "ps=${limit}"
)
[[ -n "${query}" ]] && args+=(--data-urlencode "q=${query}")

response="$(sonar::api "/api/components/tree" "${args[@]}")"

if [[ "${raw}" == true ]]; then
  echo "${response}" | jq .
else
  echo "${response}" | jq '{
        paging: .paging,
        components: [.components[] | {key, name, path, qualifier}]
    }'
fi
