# Brandon's Dotfiles

Portable machine bootstrap repo, modeled after Manuel Chichi's chezmoi-based dotfiles.

## What it manages

- `~/.zshrc` with existing shell helpers, `fnox` secret lookups, `mise`, Bun, pnpm, and agent helpers
- `~/.gitconfig` templated from install-time name/email prompts
- `~/.tmux.conf` plus TPM via chezmoi externals
- GUI-only configs for Ghostty and Zed when `desktop=true`
- Conservative package bootstrap for Arch/CachyOS and Debian/Ubuntu

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

- `name`: Git display name
- `email`: Git email
- `work`: enables future work-only package/config sections
- `desktop`: installs/includes GUI configs like Ghostty and Zed

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

## Safety notes

- Do **not** commit `~/.ssh`, API tokens, browser profiles, caches, or generated app databases.
- This repo keeps secret *lookups* in `.zshrc`, not secret values.
- Run `chezmoi diff` before `chezmoi apply` on every new machine.
