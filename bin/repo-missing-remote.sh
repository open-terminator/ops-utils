#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  repo-missing-remote.sh [root-dir] [remote-name]

Defaults:
  root-dir: current directory
  remote-name: origin
EOF
}

if [[ ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

root_dir="${1:-.}"
remote_name="${2:-origin}"

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

  if git -C "$dir" remote get-url "$remote_name" >/dev/null 2>&1; then
    continue
  fi

  reported=1
  printf '%s [%s] is missing remote %s\n' "$repo" "$branch" "$remote_name"
done

if [[ "$found" -eq 0 ]]; then
  echo "No git repositories found under $root_dir" >&2
  exit 1
fi

if [[ "$reported" -eq 0 ]]; then
  echo "All repositories under $root_dir have remote $remote_name configured"
fi
