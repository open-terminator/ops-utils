#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  new-repo-from-template.sh <template> <target-dir> <project-name>

Example:
  new-repo-from-template.sh generic ./demo demo
EOF
}

if [[ ${1:-} == "--help" || $# -lt 3 ]]; then
  usage
  exit 0
fi

template="$1"
target_dir="$2"
project_name="$3"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
default_factory_root="$(cd "$script_dir/../../repo-factory/templates" 2>/dev/null && pwd || true)"
factory_root="${REPO_FACTORY_TEMPLATES_DIR:-$default_factory_root}"
source_dir="$factory_root/$template"

if [[ -z "$factory_root" || ! -d "$source_dir" ]]; then
  echo "Template not found: $template" >&2
  echo "Set REPO_FACTORY_TEMPLATES_DIR if repo-factory is not located next to ops-utils." >&2
  exit 1
fi

mkdir -p "$target_dir"
cp -R "$source_dir"/. "$target_dir"/

module_name=$(printf '%s' "$project_name" | tr '-' '_')
script_name=$(printf '%s' "$project_name" | tr ' ' '-')

find "$target_dir" -depth -type f | while read -r f; do
  dir=$(dirname "$f")
  base=$(basename "$f")
  new_base="${base//\{\{PROJECT_NAME\}\}/$project_name}"
  new_base="${new_base//\{\{MODULE_NAME\}\}/$module_name}"
  new_base="${new_base//\{\{SCRIPT_NAME\}\}/$script_name}"
  if [[ "$base" != "$new_base" ]]; then
    mv "$f" "$dir/$new_base"
  fi
done

find "$target_dir" -type f \( -name '*.md' -o -name '*.txt' -o -name '*.sh' -o -name '*.template' -o -name 'gitignore' \) -print0 | while IFS= read -r -d '' file; do
  sed -i "s/{{PROJECT_NAME}}/$project_name/g" "$file" || true
  sed -i "s/{{MODULE_NAME}}/$module_name/g" "$file" || true
  sed -i "s/{{SCRIPT_NAME}}/$script_name/g" "$file" || true
done

find "$target_dir" -depth -type f | while read -r f; do
  base=$(basename "$f")
  dir=$(dirname "$f")
  case "$base" in
    *.template)
      mv "$f" "${f%.template}"
      ;;
    *.template.*)
      new_base="${base/.template./.}"
      mv "$f" "$dir/$new_base"
      ;;
  esac
done

if [[ -f "$target_dir/script.sh" ]]; then
  chmod +x "$target_dir/script.sh"
fi
if [[ -f "$target_dir/gitignore" ]]; then
  mv "$target_dir/gitignore" "$target_dir/.gitignore"
fi

if [[ ! -d "$target_dir/.git" ]]; then
  git -C "$target_dir" init >/dev/null 2>&1 || true
  git -C "$target_dir" branch -M main >/dev/null 2>&1 || true
fi

echo "Created project '$project_name' in $target_dir from template '$template'"
