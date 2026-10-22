#!/usr/bin/env bash
# Search security hotspots, or show the full detail of a single hotspot.
# API: GET /api/hotspots/search, GET /api/hotspots/show
#
# Usage: hotspots.sh [--status TO_REVIEW|REVIEWED] [--limit 50] [--page 1] [--raw]
#        hotspots.sh --key <hotspotKey>   # full detail, including vulnerability explanation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

status=""
limit="50"
page="1"
key=""
raw=false

while [[ $# -gt 0 ]]; do
  case "$1" in
  --status)
    status="$2"
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
  --key)
    key="$2"
    shift 2
    ;;
  --raw)
    raw=true
    shift
    ;;
  -h | --help)
    echo "Usage: $(basename "$0") [--status TO_REVIEW|REVIEWED] [--limit 50] [--page 1] [--raw]"
    echo "       $(basename "$0") --key <hotspotKey>"
    exit 0
    ;;
  *) sonar::usage_and_exit "Unknown argument: $1" ;;
  esac
done

if [[ -n "${key}" ]]; then
  response="$(sonar::api "/api/hotspots/show" --data-urlencode "hotspot=${key}")"
  if [[ "${raw}" == true ]]; then
    echo "${response}" | jq .
  else
    echo "${response}" | jq '{
            key, status, resolution, message,
            rule: .rule.name,
            vulnerabilityDescription: .rule.vulnerabilityProbability,
            component: .component.key, line: .line,
            riskDescription: .rule.riskDescription,
            fixRecommendations: .rule.fixRecommendations
        }'
  fi
  exit 0
fi

project_key="$(sonar::project_key)"
args=(
  --data-urlencode "projectKey=${project_key}"
  --data-urlencode "ps=${limit}"
  --data-urlencode "p=${page}"
)
[[ -n "${status}" ]] && args+=(--data-urlencode "status=${status}")

response="$(sonar::api "/api/hotspots/search" "${args[@]}")"

if [[ "${raw}" == true ]]; then
  echo "${response}" | jq .
else
  echo "${response}" | jq '{
        total: .paging.total,
        paging: .paging,
        hotspots: [.hotspots[] | {
            key, status, resolution,
            vulnerabilityProbability, securityCategory,
            component, line, message
        }]
    }'
fi
