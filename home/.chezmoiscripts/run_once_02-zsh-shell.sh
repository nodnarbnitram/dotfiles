#!/usr/bin/env bash
set -euo pipefail

echo "--- Setting zsh as login shell ---"
if command -v zsh >/dev/null 2>&1 && [ "${SHELL:-}" != "$(command -v zsh)" ]; then
  sudo chsh -s "$(command -v zsh)" "$(whoami)"
else
  echo "zsh already configured or unavailable"
fi
