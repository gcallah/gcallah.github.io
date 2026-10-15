# Shared helpers for the Superset lifecycle scripts (sourced, not executed).

# Pick the Jekyll binary. Prefer 3.x (closest to GitHub Pages); fall back to
# whatever `jekyll` is on PATH. There is no Gemfile (GitHub Pages' legacy
# build doesn't need one); keep Jekyll from looking for Bundler anyway.
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
