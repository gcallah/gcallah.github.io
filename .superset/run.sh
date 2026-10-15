#!/usr/bin/env bash
# Superset Run: start `jekyll serve` on a per-workspace port so parallel
# workspaces don't collide on 4000.
set -euo pipefail
cd "$(dirname "$0")/.."
. ./.superset/lib.sh

JEKYLL="$(jekyll_cmd)"
if [ -z "$JEKYLL" ]; then
  echo "ERROR: no 'jekyll' found; see .superset/setup.sh" >&2
  exit 1
fi

# Stable starting port per workspace (hash into 4000-4999), then probe
# forward until a free one is found. PORT env var overrides.
if [ -z "${PORT:-}" ]; then
  key="${SUPERSET_WORKSPACE_NAME:-${SUPERSET_WORKSPACE_PATH:-$PWD}}"
  hash=$(printf '%s' "$key" | cksum | cut -d' ' -f1)
  PORT=$((4000 + hash % 1000))
  tries=0
  while lsof -nP -iTCP:"$PORT" -sTCP:LISTEN >/dev/null 2>&1; do
    PORT=$((PORT + 1)); [ "$PORT" -gt 4999 ] && PORT=4000
    tries=$((tries + 1))
    if [ "$tries" -ge 1000 ]; then echo "ERROR: no free port in 4000-4999" >&2; exit 1; fi
  done
fi

echo "Serving at http://127.0.0.1:$PORT/"
echo $$ > "$(pidfile)"
# --disable-disk-cache keeps Jekyll 4 from writing .jekyll-cache/ (ignored by 3.x).
extra=""
case "$JEKYLL" in *_3.*) ;; *) extra="--disable-disk-cache" ;; esac
exec $JEKYLL serve --host 127.0.0.1 --port "$PORT" $extra
