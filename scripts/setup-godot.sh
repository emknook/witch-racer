#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
version="$(tr -d '[:space:]' < "$repository_root/.godot-version")"
platform="$(uname -s)"
architecture="$(uname -m)"
install_directory="$repository_root/.tools/godot/$version"
executable="$install_directory/godot"

if [[ "$platform" != "Linux" || "$architecture" != "x86_64" ]]; then
  echo "This setup script supports Linux x86_64. For Windows, use setup-godot.ps1." >&2
  exit 1
fi

if [[ -x "$executable" ]]; then
  "$executable" --version
  echo "Godot already installed: $executable"
  exit 0
fi

archive_url="https://github.com/godotengine/godot/releases/download/${version}-stable/Godot_v${version}-stable_linux.x86_64.zip"
mkdir -p "$install_directory"
temporary_archive="$(mktemp)"
trap 'rm -f "$temporary_archive"' EXIT

echo "Downloading Godot $version for Linux x86_64..."
curl --fail --location --retry 3 --silent --show-error "$archive_url" --output "$temporary_archive"
unzip -j -q "$temporary_archive" -d "$install_directory"
downloaded_binary="$install_directory/Godot_v${version}-stable_linux.x86_64"
mv "$downloaded_binary" "$executable"
chmod +x "$executable"
"$executable" --version
echo "Godot installed: $executable"
