#!/usr/bin/env bash
# Shared helpers for the sonarcloud-for-this-project scripts.
# Sourced by every script in ../scripts — not meant to be executed directly.

set -o errexit
set -o pipefail
set -o nounset

sonar::die() {
  echo "[ERROR] $*" >&2
  exit 1
}

sonar::require_bin() {
  for bin in "$@"; do
    command -v "${bin}" >/dev/null 2>&1 || sonar::die "Required command '${bin}' is not installed."
  done
}

sonar::require_env() {
  local missing=()
  [[ -n "${SONARCLOUD_TOKEN:-}" ]] || missing+=("SONARCLOUD_TOKEN")
  [[ -n "${SONARQUBE_URL:-}" ]] || missing+=("SONARQUBE_URL")
  [[ -n "${SONARQUBE_ORGANIZATION:-}" ]] || missing+=("SONARQUBE_ORGANIZATION")

  if [[ ${#missing[@]} -gt 0 ]]; then
    sonar::die "Missing required environment variable(s): ${missing[*]}. This skill expects a devcontainer with SONARCLOUD_TOKEN, SONARQUBE_URL and SONARQUBE_ORGANIZATION set (see .devcontainer/devcontainer.json)."
  fi
}

# Resolve the SonarCloud project key.
# Override with SONARCLOUD_PROJECT_KEY if the project does not follow the
# default SonarCloud convention of "<organization>_<repo-name>".
sonar::project_key() {
  sonar::require_env

  if [[ -n "${SONARCLOUD_PROJECT_KEY:-}" ]]; then
    echo "${SONARCLOUD_PROJECT_KEY}"
    return
  fi

  command -v git >/dev/null 2>&1 || sonar::die "git is not installed and SONARCLOUD_PROJECT_KEY is not set."

  local remote_url repo_name
  remote_url="$(git remote get-url origin 2>/dev/null)" || sonar::die "Could not determine the project key: not a git repository with an 'origin' remote. Set SONARCLOUD_PROJECT_KEY explicitly."
  repo_name="$(basename -s .git "${remote_url}")"

  echo "${SONARQUBE_ORGANIZATION}_${repo_name}"
}

# sonar::api <endpoint-path> [extra curl args...]
# Calls the SonarCloud Web API with auth and the configured organization,
# prints the JSON response body on stdout, and fails loudly on HTTP errors.
sonar::api() {
  local endpoint="$1"
  shift

  sonar::require_env
  sonar::require_bin curl jq

  local url="${SONARQUBE_URL%/}${endpoint}"
  local tmp_body http_status
  tmp_body="$(mktemp)"
  trap 'rm -f "${tmp_body}"' RETURN

  http_status="$(curl -sS -G \
    -u "${SONARCLOUD_TOKEN}:" \
    -o "${tmp_body}" \
    -w "%{http_code}" \
    "$@" \
    "${url}")"

  if [[ "${http_status}" -lt 200 || "${http_status}" -ge 300 ]]; then
    echo "[ERROR] SonarCloud API request to ${endpoint} failed with HTTP ${http_status}:" >&2
    jq . "${tmp_body}" >&2 2>/dev/null || cat "${tmp_body}" >&2
    exit 1
  fi

  cat "${tmp_body}"
}

sonar::usage_and_exit() {
  echo "$1" >&2
  exit 1
}
