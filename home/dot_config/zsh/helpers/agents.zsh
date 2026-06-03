# Coding-agent helpers. Public-safe; tokens and provider config belong in private.zsh.

export OPENCODE_EXPERIMENTAL_OXFMT=true

_agent_with_zenity_sudo() {
  AI_AGENT_SUDO_ASKPASS=1 \
  SUDO_ASKPASS="$HOME/.local/bin/zenity-sudo-askpass" \
  command "$@"
}

opencode() {
  _agent_with_zenity_sudo opencode "$@"
}

claude() {
  _agent_with_zenity_sudo claude "$@"
}

pi() {
  _agent_with_zenity_sudo pi "$@"
}

agent-shell() {
  AI_AGENT_SUDO_ASKPASS=1 \
  SUDO_ASKPASS="$HOME/.local/bin/zenity-sudo-askpass" \
  "${SHELL:-/usr/bin/zsh}" -l "$@"
}
