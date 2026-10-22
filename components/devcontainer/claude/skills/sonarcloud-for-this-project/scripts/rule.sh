#!/usr/bin/env bash
# Show the full description of a rule (why an issue/hotspot was raised, how to fix it).
# API: GET /api/rules/show
#
# Usage: rule.sh --key <ruleKey> [--raw]
# Example: rule.sh --key java:S2259

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

key=""
raw=false

while [[ $# -gt 0 ]]; do
  case "$1" in
  --key)
    key="$2"
    shift 2
    ;;
  --raw)
    raw=true
    shift
    ;;
  -h | --help)
    echo "Usage: $(basename "$0") --key <ruleKey> [--raw]"
    exit 0
    ;;
  *) sonar::usage_and_exit "Unknown argument: $1" ;;
  esac
done

[[ -n "${key}" ]] || sonar::usage_and_exit "Missing required --key <ruleKey>."

response="$(sonar::api "/api/rules/show" --data-urlencode "key=${key}")"

if [[ "${raw}" == true ]]; then
  echo "${response}" | jq .
else
  echo "${response}" | jq '.rule | {
        key, name, severity, type,
        htmlDesc, remFnBaseEffort
    }'
fi
