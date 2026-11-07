#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
version="$(tr -d '[:space:]' < "$repository_root/.godot-version")"
executable="$repository_root/.tools/godot/$version/godot"

if [[ ! -x "$executable" ]]; then
  bash "$repository_root/scripts/setup-godot.sh"
fi

exec "$executable" --path "$repository_root/game" "$@"
