#!/usr/bin/env bash
set -euo pipefail

echo "--- Installing tmux plugins ---"
if [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
fi
