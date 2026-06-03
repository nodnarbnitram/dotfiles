#!/usr/bin/env bash
set -euo pipefail

echo "--- Ensuring mise exists ---"
if command -v mise >/dev/null 2>&1; then
  echo "mise already installed"
else
  curl https://mise.run | sh
fi
