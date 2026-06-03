#!/usr/bin/env bash
set -euo pipefail

repo_url="${1:-}"
if ! command -v chezmoi >/dev/null 2>&1; then
  echo "Installing chezmoi..."
  if command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm chezmoi
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y chezmoi
  else
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi

if [ -n "$repo_url" ]; then
  chezmoi init "$repo_url"
else
  chezmoi init --source "$(cd "$(dirname "$0")" && pwd)"
fi

chezmoi diff || true
read -r -p "Apply these changes? [y/N] " answer
case "$answer" in
  y|Y|yes|YES) chezmoi apply ;;
  *) echo "Aborted before apply." ;;
esac
