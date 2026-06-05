# Common PATH entries. These are harmless when directories do not exist.

typeset -U path PATH

path=(
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/usr/local/bin"
  "/usr/local/sbin"
  "$HOME/.local/bin"
  "$HOME/.npm-global/bin"
  "$HOME/.cargo/bin"
  "$HOME/.opencode/bin"
  "$HOME/.brv-cli/bin"
  "$HOME/.lmstudio/bin"
  $path
)

export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL/bin" ] && path=("$BUN_INSTALL/bin" $path)

export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
[ -d "$PNPM_HOME" ] && path=("$PNPM_HOME" $path)

[ -r "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

export PATH
