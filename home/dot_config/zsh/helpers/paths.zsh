# Common PATH entries. These are harmless when directories do not exist.

typeset -U path PATH

path=(
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
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
[ -d "$PNPM_HOME" ] && path=("$PNPM_HOME" $path)

[ -r "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

export PATH
