#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  repo-remotes.sh [root-dir]

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

for dir in "$root_dir"/*; do
  [[ -d "$dir/.git" ]] || continue
  found=1

  repo=$(basename "$dir")
  printf '%s\n' "$repo"

  remotes=$(git -C "$dir" remote 2>/dev/null || true)
  if [[ -z "$remotes" ]]; then
    echo "  (no remotes configured)"
    printf '\n'
    continue
  fi

  while IFS= read -r remote_name; do
    [[ -n "$remote_name" ]] || continue
    remote_url=$(git -C "$dir" remote get-url "$remote_name" 2>/dev/null || echo '(url unavailable)')
    printf '  %s %s\n' "$remote_name" "$remote_url"
  done <<<"$remotes"

  printf '\n'
done

if [[ "$found" -eq 0 ]]; then
  echo "No git repositories found under $root_dir" >&2
  exit 1
fi
