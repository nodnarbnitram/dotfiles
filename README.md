# Brandon's Dotfiles

Portable machine bootstrap repo, modeled after Manuel Chichi's chezmoi-based dotfiles.

This repo is Brandon's **Shareable Base**: real daily configuration that is safe to reuse across machines. Private overlays and local files carry secrets, work-specific values, and machine-only state.

## What it manages

- `~/.zshrc` as a small loader for XDG zsh helpers, zimfw, Pure, `mise`, Bun, pnpm, and optional private includes
- `~/.gitconfig` templated from install-time name/email prompts
- `~/.tmux.conf` plus TPM via chezmoi externals
- GUI-only Ghostty config when `desktop=true`
- Conservative package bootstrap for Arch/CachyOS, Debian/Ubuntu, and macOS/Homebrew
- zimfw + Pure prompt stack on all supported Linux/macOS machines
- global mise-managed toolchain for Node, pnpm, Bun, Rust, Go, Python, uv, fnox, code-quality CLIs, Rust audit/test tools, pi, and context-mode
- public-safe secret tooling bootstrap for `fnox`; secret config stays private
- `~/.local/bin/zenity-sudo-askpass` for GUI sudo prompts in agent shells
- Aikido Safe Chain install and managed zsh shell integration when available

## First install on a new machine

```sh
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

After the public base applies, `install.sh` can optionally apply a private overlay. Use the default `~/dotfiles-private` or enter a private Git URL; remote overlays are cloned into `${XDG_DATA_HOME:-~/.local/share}/chezmoi-private` and applied as a second chezmoi source.

Package lists live in `home/.chezmoidata/packages.yaml` and are rendered into `run_onchange_before_*` install scripts, so package installation re-runs only when the declared package lists change. On macOS, Homebrew is used when available even if it is installed at `/opt/homebrew/bin/brew` but not yet on the shell `PATH`, and packages are installed with an embedded `brew bundle` script.

After each apply, the repo offers an optional interactive upgrade pass for OS packages, mise-managed tools, zimfw modules, and tmux plugins. Set `DOTFILES_SKIP_UPGRADE=1` to suppress the prompt or `DOTFILES_UPGRADE=1` to run the pass non-interactively.

For a remote-only bootstrap after publishing:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <your-repo-url>
```

During `chezmoi init`, answer:

- `editor`: default terminal editor command, for example `vim`, `nvim`, `zeditor`, `zed`, `cursor`, or `code`. GUI editor commands `zeditor`, `zed`, `cursor`, and `code` automatically get `--wait` for Git and `sudoedit` when missing.
- `work`: enables future work-only package/config sections
- `desktop`: installs/includes GUI configs like Ghostty

The managed public `~/.gitconfig` does **not** commit a Git identity. During install, you can optionally generate local-only machine identity config:

- default/global Git display name and email
- folder-specific identities for repos under paths like `~/Projects/weshipwork/`

Those values are written outside chezmoi to `~/.config/git/local.inc` and `~/.config/git/identities/*.inc`. They are not committed to this repo.

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

## Syncing changes

Edit managed files under `home/`, then render them onto the current machine:

```sh
chezmoi diff
chezmoi apply
```

If this checkout is not the active chezmoi source, run from the repo root with an explicit source:

```sh
chezmoi --source home diff
chezmoi --source home apply
```

When `home/.chezmoi.yaml.tmpl` changes, regenerate chezmoi's local config before applying:

```sh
chezmoi init --source "$(pwd)/home"
chezmoi apply
```

When `home/dot_config/mise/config.toml.tmpl` changes, apply the rendered mise config and install the declared tools:

```sh
chezmoi apply ~/.config/mise/config.toml
mise install
```

On another machine that already has this repo configured:

```sh
git pull
chezmoi apply
mise install
```

If the machine uses chezmoi's source checkout directly, `chezmoi update` can replace `git pull && chezmoi apply`.

## Repo rules

Read `AGENTS.md` before making structural changes. The short version:

- preserve the Shareable Base; do not genericize real public-safe preferences
- keep Forbidden Material out of git, including secret names and provider config
- do not commit Git identity values here; `install.sh` may create local-only Git identity files outside chezmoi
- use XDG paths where tools support them cleanly
- keep `~/.zshrc` as a small loader; add shell behavior as helper modules under `home/dot_config/zsh/helpers/`
- number chezmoi scripts within their phase, for example `run_once_01-*`, `run_once_after_01-*`, and `run_after_01-*`
- validate rendered templates and dry-run role-specific installs before committing

## Safety notes

- Do **not** commit `~/.ssh`, API tokens, browser profiles, caches, or generated app databases.
- Do **not** commit internal DNS names, private IP ranges, VPN config, or machine-specific editor/app config.
- Put private shell customizations and secret activation in `~/.config/zsh/private.zsh`; `.zshrc` sources it when present, but the shareable base does not manage it.
- Run `chezmoi diff` before `chezmoi apply` on every new machine.
