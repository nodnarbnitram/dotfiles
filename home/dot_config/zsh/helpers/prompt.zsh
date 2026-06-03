# Pure prompt setup. zimfw installs and loads Pure; this activates it.

if (( $+functions[promptinit] == 0 )); then
  autoload -Uz promptinit
fi

promptinit

# Keep defaults intentionally light; customize in private.zsh when needed.
zstyle ':prompt:pure:git:stash' show yes

prompt pure 2>/dev/null || true
