#!/usr/bin/env bash
set -euo pipefail

expand_path() {
  case "$1" in
    "~") printf '%s\n' "$HOME" ;;
    "~/"*) printf '%s/%s\n' "$HOME" "${1#~/}" ;;
    *) printf '%s\n' "$1" ;;
  esac
}

looks_like_git_url() {
  case "$1" in
    http://*|https://*|ssh://*|git@*:*|*.git) return 0 ;;
    *) return 1 ;;
  esac
}

private_overlay_source() {
  local overlay_ref="$1"
  local overlay_path
  overlay_path="$(expand_path "$overlay_ref")"

  if [ -d "$overlay_path" ]; then
    printf '%s\n' "$overlay_path"
    return 0
  fi

  if looks_like_git_url "$overlay_ref"; then
    local source_parent source_dir
    source_parent="${XDG_DATA_HOME:-$HOME/.local/share}"
    source_dir="$source_parent/chezmoi-private"

    if [ -d "$source_dir/.git" ]; then
      git -C "$source_dir" pull --ff-only
    else
      mkdir -p "$source_parent"
      git clone "$overlay_ref" "$source_dir"
    fi

    printf '%s\n' "$source_dir"
    return 0
  fi

  echo "Private overlay not found: $overlay_ref" >&2
  return 1
}

apply_private_overlay() {
  local answer overlay_ref overlay_source

  read -r -p "Apply a private dotfiles overlay too? [y/N] " answer
  case "$answer" in
    y|Y|yes|YES) ;;
    *) return 0 ;;
  esac

  read -r -p "Private overlay path or Git URL [~/dotfiles-private]: " overlay_ref
  overlay_ref="${overlay_ref:-~/dotfiles-private}"
  overlay_source="$(private_overlay_source "$overlay_ref")"

  echo "--- Private overlay diff: $overlay_source ---"
  chezmoi --source "$overlay_source" diff || true

  read -r -p "Apply private overlay changes? [y/N] " answer
  case "$answer" in
    y|Y|yes|YES) chezmoi --source "$overlay_source" apply ;;
    *) echo "Aborted private overlay before apply." ;;
  esac
}

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
  y|Y|yes|YES)
    chezmoi apply
    apply_private_overlay
    ;;
  *) echo "Aborted before apply." ;;
esac
