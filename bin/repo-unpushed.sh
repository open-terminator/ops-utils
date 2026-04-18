#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  repo-unpushed.sh [root-dir]

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

  if [[ -z "$upstream" ]]; then
    continue
  fi

  ahead_count=$(git -C "$dir" rev-list --count "$upstream"..HEAD 2>/dev/null || echo '0')
  if [[ "$ahead_count" == "0" ]]; then
    continue
  fi

  reported=1
  printf '%s [%s -> %s] %s unpushed commit(s)\n' "$repo" "$branch" "$upstream" "$ahead_count"
  git -C "$dir" log --reverse --format='  %h %s' "$upstream"..HEAD
  printf '\n'
done

if [[ "$found" -eq 0 ]]; then
  echo "No git repositories found under $root_dir" >&2
  exit 1
fi

if [[ "$reported" -eq 0 ]]; then
  echo "No unpushed commits found under $root_dir"
fi
