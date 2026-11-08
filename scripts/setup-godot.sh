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

archive_name="Godot_v${version}-stable_linux.x86_64.zip"
primary_url="https://github.com/godotengine/godot/releases/download/${version}-stable/$archive_name"
mirror_url="https://downloads.sourceforge.net/project/godot-engine.mirror/${version}-stable/$archive_name"
mkdir -p "$install_directory"
temporary_archive="$(mktemp)"
trap 'rm -f "$temporary_archive"' EXIT

download_archive() {
  local url="$1"
  echo "Downloading Godot $version from $url..."
  curl --fail --location --retry 5 --retry-all-errors --retry-delay 5 \
    --connect-timeout 20 --max-time 240 --silent --show-error \
    "$url" --output "$temporary_archive"
}

if ! download_archive "$primary_url"; then
  echo "Primary download failed; trying SourceForge's Godot mirror." >&2
  rm -f "$temporary_archive"
  download_archive "$mirror_url"
fi
unzip -tq "$temporary_archive" > /dev/null
unzip -j -q "$temporary_archive" -d "$install_directory"
downloaded_binary="$install_directory/Godot_v${version}-stable_linux.x86_64"
mv "$downloaded_binary" "$executable"
chmod +x "$executable"
"$executable" --version
echo "Godot installed: $executable"
