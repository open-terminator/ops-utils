#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  repo-missing-file.sh [root-dir] [relative-path]

Defaults:
  root-dir: current directory
  relative-path: LICENSE
EOF
}

is_git_repo() {
  local dir="$1"
  [[ -e "$dir/.git" ]] || return 1
  git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1
}

if [[ ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

root_dir="${1:-.}"
relative_path="${2:-LICENSE}"

if [[ ! -d "$root_dir" ]]; then
  echo "Root directory not found: $root_dir" >&2
  exit 1
fi

if [[ -z "$relative_path" ]]; then
  echo "Relative path must not be empty" >&2
  exit 1
fi

found=0
reported=0

for dir in "$root_dir"/*; do
  [[ -d "$dir" ]] || continue
  is_git_repo "$dir" || continue
  found=1

  repo=$(basename "$dir")

  if [[ -e "$dir/$relative_path" ]]; then
    continue
  fi

  reported=1
  printf '%s is missing %s\n' "$repo" "$relative_path"
done

if [[ "$found" -eq 0 ]]; then
  echo "No git repositories found under $root_dir" >&2
  exit 1
fi

if [[ "$reported" -eq 0 ]]; then
  echo "All repositories under $root_dir contain $relative_path"
fi
