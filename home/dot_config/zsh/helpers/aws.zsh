# Work-only AWS helpers. Account names, SSO URLs, and profile defaults stay private.

assol() {
  if [[ -z "$1" ]]; then
    echo "usage: assol <aws-profile>" >&2
    return 2
  fi

  local aws_profile="$1"
  aws sso login --profile "$aws_profile" || return
  export AWS_PROFILE="$aws_profile"
  eval "$(aws configure export-credentials --profile "$aws_profile" --format env)"
}

aws-profiles() {
  awk -F '[][]' '/^\[profile / { sub(/^profile /, "", $2); print $2 }' "$HOME/.aws/config" 2>/dev/null
}

switch-aws() {
  if [[ -z "$1" ]]; then
    echo "usage: switch-aws <aws-profile>" >&2
    return 2
  fi

  local aws_profile="$1"
  export AWS_PROFILE="$aws_profile"
  eval "$(aws configure export-credentials --profile "$aws_profile" --format env)"
}
