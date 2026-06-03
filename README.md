# Brandon's Dotfiles

Portable machine bootstrap repo, modeled after Manuel Chichi's chezmoi-based dotfiles.

This repo is Brandon's **Shareable Base**: real daily configuration that is safe to reuse across machines. Private overlays and local files carry secrets, work-specific values, and machine-only state.

## What it manages

- `~/.zshrc` as a small loader for XDG zsh helpers, zimfw, Pure, `mise`, Bun, pnpm, and optional private includes
- `~/.gitconfig` templated from install-time name/email prompts
- `~/.tmux.conf` plus TPM via chezmoi externals
- GUI-only Ghostty config when `desktop=true`
- Conservative package bootstrap for Arch/CachyOS and Debian/Ubuntu
- zimfw + Pure prompt stack on all supported Linux/macOS machines
- public-safe secret tooling bootstrap for `fnox`; secret config stays private
- `~/.local/bin/zenity-sudo-askpass` for GUI sudo prompts in agent shells

## First install on a new machine

```sh
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

For a remote-only bootstrap after publishing:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <your-repo-url>
```

During `chezmoi init`, answer:

- `editor`: default terminal editor command, for example `vim`, `nvim`, or `code --wait`
- `work`: enables future work-only package/config sections
- `desktop`: installs/includes GUI configs like Ghostty

This repo does **not** set global Git identity. Configure `user.name` and `user.email` per repository, for example:

```sh
git config user.email "person@example.com"
git config user.name "Your Name"
```

## Daily workflow

```sh
chezmoi status
chezmoi diff
chezmoi apply
chezmoi cd
```

Add a new file:

```sh
chezmoi add ~/.config/example/config.toml
chezmoi cd
git status
git add . && git commit -m "Add example config"
```

## Repo rules

Read `AGENTS.md` before making structural changes. The short version:

- preserve the Shareable Base; do not genericize real public-safe preferences
- keep Forbidden Material out of git, including secret names and provider config
- do not set global Git identity here; use per-repo `git config user.email ...`
- use XDG paths where tools support them cleanly
- keep `~/.zshrc` as a small loader; add shell behavior as helper modules under `home/dot_config/zsh/helpers/`
- number chezmoi scripts within their phase, for example `run_once_01-*`, `run_once_after_01-*`, and `run_after_01-*`
- validate rendered templates and dry-run role-specific installs before committing

## Safety notes

- Do **not** commit `~/.ssh`, API tokens, browser profiles, caches, or generated app databases.
- Do **not** commit internal DNS names, private IP ranges, VPN config, or machine-specific editor/app config.
- Put private shell customizations and secret activation in `~/.config/zsh/private.zsh`; `.zshrc` sources it when present, but the shareable base does not manage it.
- Run `chezmoi diff` before `chezmoi apply` on every new machine.
