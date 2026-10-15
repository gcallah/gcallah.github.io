#!/usr/bin/env bash
# Superset workspace setup: copy untracked local files from the main
# checkout and make sure a usable Jekyll is installed.
set -euo pipefail
cd "$(dirname "$0")/.."
. ./.superset/lib.sh

# 1. Copy untracked local files (env/secrets) from the main checkout.
ROOT="${SUPERSET_ROOT_PATH:-}"
if [ -n "$ROOT" ] && [ -d "$ROOT" ] && [ "$(cd "$ROOT" && pwd -P)" != "$(pwd -P)" ]; then
  for f in "$ROOT"/.env "$ROOT"/.env.* "$ROOT"/.superset/config.local.json; do
    [ -f "$f" ] || continue
    rel="${f#"$ROOT"/}"
    if [ ! -e "$rel" ]; then
      mkdir -p "$(dirname "$rel")"
      cp "$f" "$rel"
      echo "Copied $rel from main checkout"
    fi
  done
else
  echo "SUPERSET_ROOT_PATH not set (or is this checkout); skipping file copy"
fi

# 2. Dependencies. There is no Gemfile, so we rely on a globally installed
#    Jekyll.
JEKYLL="$(jekyll_cmd)"
if [ -z "$JEKYLL" ]; then
  echo "ERROR: no 'jekyll' found on PATH. Install it with: gem install jekyll -v '~> 3.9'" >&2
  exit 1
fi
echo "Using: $($JEKYLL --version 2>/dev/null | tail -1)"
echo "Setup complete. Click Run to start the dev server."
