#!/usr/bin/env bash
# Superset workspace teardown: stop the Jekyll server started by run.sh
# (if still running) and remove build output. Never fails deletion.
cd "$(dirname "$0")/.." || exit 0
. ./.superset/lib.sh

PIDFILE="$(pidfile 2>/dev/null || true)"
if [ -n "$PIDFILE" ] && [ -f "$PIDFILE" ]; then
  pid="$(cat "$PIDFILE")"
  # Only kill it if it's still a jekyll process (PIDs get reused).
  if [ -n "$pid" ] && ps -p "$pid" -o command= 2>/dev/null | grep -q jekyll; then
    echo "Stopping Jekyll server (pid $pid)"
    kill "$pid" 2>/dev/null || true
    for _ in 1 2 3 4 5; do kill -0 "$pid" 2>/dev/null || break; sleep 1; done
    kill -9 "$pid" 2>/dev/null || true
  fi
  rm -f "$PIDFILE"
fi
rm -rf _site .jekyll-cache .sass-cache .jekyll-metadata
exit 0
