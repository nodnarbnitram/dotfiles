# Brandon's Dotfiles

Portable machine bootstrap repo, modeled after Manuel Chichi's chezmoi-based dotfiles.

## What it manages

- `~/.zshrc` as a small loader for XDG zsh helpers, zimfw, Pure, `mise`, Bun, pnpm, and optional private includes
- `~/.gitconfig` templated from install-time name/email prompts
- `~/.tmux.conf` plus TPM via chezmoi externals
- GUI-only Ghostty config when `desktop=true`
- Conservative package bootstrap for Arch/CachyOS and Debian/Ubuntu
- zimfw + Pure prompt stack on all supported Linux/macOS machines
- public-safe secret tooling bootstrap for `fnox`; secret config stays private

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
- `editor`: default terminal editor command, for example `vim`, `nvim`, or `code --wait`
- `work`: enables future work-only package/config sections
- `desktop`: installs/includes GUI configs like Ghostty

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
- Do **not** commit internal DNS names, private IP ranges, VPN config, or machine-specific editor/app config.
- Put private shell customizations and secret activation in `~/.config/zsh/private.zsh`; `.zshrc` sources it when present, but the shareable base does not manage it.
- Run `chezmoi diff` before `chezmoi apply` on every new machine.
