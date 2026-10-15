# Shared helpers for the Superset lifecycle scripts (sourced, not executed).

# Pick the Jekyll binary. Prefer 3.x (closest to GitHub Pages); fall back to
# whatever `jekyll` is on PATH. Bundler is bypassed because the Gemfile.lock
# pins 2016-era gems that no longer build on this machine's Ruby.
export JEKYLL_NO_BUNDLER_REQUIRE=true

jekyll_cmd() {
  if jekyll _3.9.0_ --version >/dev/null 2>&1; then
    echo "jekyll _3.9.0_"
  elif command -v jekyll >/dev/null 2>&1; then
    echo "jekyll"
  fi
}

# Per-worktree pidfile, stored inside the worktree's git dir so it never
# shows up in `git status`.
pidfile() {
  git rev-parse --git-path superset-jekyll.pid
}
