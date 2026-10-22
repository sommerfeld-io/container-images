#!/usr/bin/env bash
# Show the duplicated code blocks for a single file.
# API: GET /api/duplications/show
#
# Usage: duplications.sh --file <fileKey> [--raw]
# Find file keys with files.sh.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# common.sh is resolved at runtime via SCRIPT_DIR; it is only followed when shellcheck runs with -x
# shellcheck source=../lib/common.sh disable=SC1091
source "${SCRIPT_DIR}/../lib/common.sh"

file=""
raw=false

while [[ $# -gt 0 ]]; do
  case "$1" in
  --file)
    file="$2"
    shift 2
    ;;
  --raw)
    raw=true
    shift
    ;;
  -h | --help)
    echo "Usage: $(basename "$0") --file <fileKey> [--raw]"
    echo "Find file keys with files.sh."
    exit 0
    ;;
  *) sonar::usage_and_exit "Unknown argument: $1" ;;
  esac
done

[[ -n "${file}" ]] || sonar::usage_and_exit "Missing required --file <fileKey>."

response="$(sonar::api "/api/duplications/show" --data-urlencode "key=${file}")"

if [[ "${raw}" == true ]]; then
  echo "${response}" | jq .
else
  echo "${response}"
fi
