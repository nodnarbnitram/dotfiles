# AGENTS.md

Instructions for AI agents and future maintainers working in this dotfiles repo.

## Core rule

This repo is a **Shareable Base**: Brandon's real daily setup minus Forbidden Material. Do not turn it into a generic starter template, and do not move real public-safe preferences into private/local files just to make the repo look cleaner.

Use `CONTEXT.md` for the project language before renaming concepts or introducing new structure.

## Privacy boundary

Never add Forbidden Material to this repo:

- API tokens, passwords, private keys, SSH config, age identities, fnox provider config, or secret names
- work hostnames, internal DNS names, private IP ranges, account IDs, SSO URLs, or company-specific defaults
- browser profiles, caches, generated app databases, or machine-local state

Public-safe tooling can live here. Secret Configuration and Secret Inventory belong in a Private Overlay or unmanaged local files. The public shell entrypoint may source `${XDG_CONFIG_HOME:-$HOME/.config}/zsh/private.zsh` if present, but this repo must not manage that file.

## Chezmoi workflow

- Edit files under `home/`, not files directly in `$HOME`.
- Prefer `chezmoi add`, `chezmoi edit`, `chezmoi diff`, and `chezmoi apply --dry-run` for managed files.
- Do not prompt for or manage global Git identity (`user.name` / `user.email`). Brandon uses different identities per repo.
- Keep `home/.chezmoiignore` aligned with Machine Role decisions (`work`, `desktop`, OS) so role-specific files are not installed where they do not belong.
- Do not manage SSH, DNS/VPN/WARP system state, or machine-specific editor/app config in the Shareable Base.

## Shell architecture

- Keep `home/dot_zshrc.tmpl` as a small conventional `~/.zshrc` loader. Do not relocate startup with `ZDOTDIR`.
- Use XDG defaults early: `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_STATE_HOME`, and `XDG_CACHE_HOME`.
- Put zsh behavior in Helper Modules under `home/dot_config/zsh/helpers/`.
- Update `home/dot_config/zsh/helpers.zsh.tmpl` when adding or removing a Helper Module.
- Organize helpers by capability, not machine role. Use chezmoi selection to decide whether a helper is installed or sourced.
- Work-only helpers, such as AWS helpers, must be absent from personal machines, not merely disabled at runtime.

## Prompt and secrets

- The Prompt Stack is zimfw + Pure + the small zsh-users module set in `home/dot_config/zsh/zimrc.tmpl`.
- Do not reintroduce Starship, powerlevel10k, or distro prompt setup into the Shareable Base unless the Prompt Stack decision is deliberately revisited.
- `fnox` is the Secret Abstraction. This repo may install fnox tooling, but must not include `fnox.toml`, provider details, secret names, key paths, or token exports.
- Agent sudo prompts use `~/.local/bin/zenity-sudo-askpass`. Keep the wrapper public-safe; it may depend on the `zenity` command but must not store or log passwords.
- Safe Chain may be installed by this repo, but chezmoi owns shell startup integration. Do not let Safe Chain append unmanaged lines to `~/.zshrc`; source `$HOME/.safe-chain/scripts/init-posix.sh` from a managed helper instead.

## Script naming and ordering

Chezmoi script numbers are local to their application phase. Do not make numbering global across phases.

Good pattern:

```text
run_once_01-...
run_once_02-...
run_once_after_01-...
run_after_01-...
```

Bad pattern:

```text
run_once_04-...
run_after_06-...
```

Remember: `once` is a run condition; `before` / `after` are phase attributes.

## Validation before committing

Before committing changes that touch templates, scripts, or shell config:

```sh
# render/syntax-check templates and scripts
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

for f in \
  home/dot_zshrc.tmpl \
  home/dot_config/zsh/helpers.zsh.tmpl \
  home/dot_config/zsh/helpers/core.zsh.tmpl \
  home/dot_config/zsh/zimrc.tmpl; do
  chezmoi --source home execute-template < "$f" > "$tmp/$(basename "$f" .tmpl)"
done

cp home/dot_config/zsh/helpers/{paths,prompt,agents,tmux,aws,tools}.zsh "$tmp/"
for f in "$tmp"/*; do zsh -n "$f"; done

for f in home/.chezmoiscripts/*.sh home/.chezmoiscripts/*.tmpl; do
  out="$tmp/$(basename "$f" .tmpl)"
  chezmoi --source home execute-template < "$f" > "$out"
  bash -n "$out"
done
```

Also run a role dry-run when changing `.chezmoiignore`, helper selection, or role-specific files:

```sh
tmp=$(mktemp -d)
cat > "$tmp/chezmoi.yaml" <<'YAML'
sourceDir: /home/nodnarb/dotfiles/home
data:
  name: Test User
  email: test@example.com
  editor: vim
  work: true
  desktop: true
YAML

chezmoi --config "$tmp/chezmoi.yaml" --destination "$tmp/home" apply --dry-run --verbose
```

Scan staged changes for secrets before committing. If a mistaken commit includes a secret or unwanted file, amend immediately and prune unreachable history before publishing.
