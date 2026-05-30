#!/bin/sh

set -eu

port="${PORT:-8000}"
output_path="${1:-${OUTPUT_PATH:-/output/generated.pdf}}"
source_url="${SOURCE_URL:-http://127.0.0.1:${port}/}"
load_pause="${LOAD_PAUSE:-2000}"

export HOME="${HOME:-/tmp/home}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-/tmp/xdg-config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-/tmp/xdg-cache}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp/xdg-runtime}"

mkdir -p \
  "${HOME}" \
  "${XDG_CONFIG_HOME}" \
  "${XDG_CACHE_HOME}" \
  "${XDG_RUNTIME_DIR}" \
  "$(dirname "${output_path}")"

cleanup() {
  if [ -n "${server_pid:-}" ] && kill -0 "${server_pid}" 2>/dev/null; then
    kill "${server_pid}"
    wait "${server_pid}" 2>/dev/null || true
  fi
}

trap cleanup EXIT INT TERM

http-server /work/reveal.js -a 0.0.0.0 -p "${port}" >/tmp/revealjs-server.log 2>&1 &
server_pid=$!

attempt=0
until wget -q -O /dev/null "http://127.0.0.1:${port}/?print-pdf"; do
  attempt=$((attempt + 1))

  if [ "${attempt}" -ge 60 ]; then
    cat /tmp/revealjs-server.log >&2
    echo "RevealJS server did not become ready in time." >&2
    exit 1
  fi

  sleep 1
done

exec decktape \
  --chrome-path /usr/local/bin/chromium-headless \
  --chrome-arg=--no-sandbox \
  --chrome-arg=--disable-setuid-sandbox \
  --chrome-arg=--disable-dev-shm-usage \
  --load-pause "${load_pause}" \
  reveal "${source_url}" "${output_path}"
