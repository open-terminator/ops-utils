#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  repo-missing-upstream.sh [root-dir]

Default root-dir:
  current directory
EOF
}

if [[ ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

root_dir="${1:-.}"

if [[ ! -d "$root_dir" ]]; then
  echo "Root directory not found: $root_dir" >&2
  exit 1
fi

found=0
reported=0

for dir in "$root_dir"/*; do
  [[ -d "$dir/.git" ]] || continue
  found=1

  repo=$(basename "$dir")
  branch=$(git -C "$dir" branch --show-current 2>/dev/null || echo '-')
  upstream=$(git -C "$dir" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || true)

  if [[ -n "$upstream" ]]; then
    continue
  fi

  reported=1
  printf '%s [%s] has no upstream branch configured\n' "$repo" "$branch"
done

if [[ "$found" -eq 0 ]]; then
  echo "No git repositories found under $root_dir" >&2
  exit 1
fi

if [[ "$reported" -eq 0 ]]; then
  echo "All repositories under $root_dir have an upstream branch configured"
fi
