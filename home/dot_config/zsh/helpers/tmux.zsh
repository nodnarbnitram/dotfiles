# tmux and opencode session helpers.

tm() {
  if [[ -z "$1" ]]; then
    tmux list-sessions
    return
  fi

  if tmux has-session -t "$1" 2>/dev/null; then
    tmux attach -t "$1"
  else
    tmux new-session -s "$1"
  fi
}

oc() {
  local port
  port=$(shuf -i 49152-65535 -n 1)
  OPENCODE_PORT="$port" opencode --port "$port" "$@"
}

oct() {
  local port session_name cmd
  port=$(shuf -i 49152-65535 -n 1)
  session_name="opencode-${port}"
  printf -v cmd "%q " "OPENCODE_PORT=$port" opencode --port "$port" "$@"
  tmux new-session -A -s "$session_name" "$cmd"
}
