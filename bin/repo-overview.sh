#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  repo-overview.sh [root-dir]

Default root-dir:
  /home/luca/projects/openclaw
EOF
}

if [[ ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

root_dir="${1:-/home/luca/projects/openclaw}"

if [[ ! -d "$root_dir" ]]; then
  echo "Root directory not found: $root_dir" >&2
  exit 1
fi

printf '%-22s %-10s %-18s %s\n' 'REPO' 'BRANCH' 'UPSTREAM' 'STATUS'
printf '%-22s %-10s %-18s %s\n' '----------------------' '----------' '------------------' '------'

found=0
for dir in "$root_dir"/*; do
  [[ -d "$dir/.git" ]] || continue
  found=1
  repo=$(basename "$dir")
  branch=$(git -C "$dir" branch --show-current 2>/dev/null || echo '-')
  upstream=$(git -C "$dir" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || echo '-')

  changes=()
  if [[ -n "$(git -C "$dir" status --short 2>/dev/null)" ]]; then
    changes+=(dirty)
  fi

  ahead_behind=$(git -C "$dir" rev-list --left-right --count HEAD..."$upstream" 2>/dev/null || true)
  if [[ -n "$ahead_behind" ]]; then
    ahead=$(awk '{print $1}' <<<"$ahead_behind")
    behind=$(awk '{print $2}' <<<"$ahead_behind")
    if [[ "$ahead" != "0" ]]; then
      changes+=(ahead:"$ahead")
    fi
    if [[ "$behind" != "0" ]]; then
      changes+=(behind:"$behind")
    fi
  fi

  if [[ ${#changes[@]} -eq 0 ]]; then
    changes+=(clean)
  fi

  status=$(IFS=, ; echo "${changes[*]}")
  printf '%-22s %-10s %-18s %s\n' "$repo" "$branch" "$upstream" "$status"
done

if [[ "$found" -eq 0 ]]; then
  echo "No git repositories found under $root_dir" >&2
  exit 1
fi
