# General CLI tool shell integrations. Secret activation belongs in private.zsh.

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
elif [ -x "$HOME/.local/bin/mise" ]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
fi

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if [ -r "$HOME/.safe-chain/scripts/init-posix.sh" ]; then
  source "$HOME/.safe-chain/scripts/init-posix.sh" # Safe-chain Zsh initialization script
fi
