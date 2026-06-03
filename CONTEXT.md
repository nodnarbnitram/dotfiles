# Dotfiles

Personal configuration files intended to make Brandon's machines feel familiar without publishing private or machine-specific material.

## Language

**Shareable Base**:
The portable, public-safe configuration that should work across Brandon's supported machines. It should preserve Brandon's real preferences, not become a generic starter template.
_Avoid_: Public base, generic base, community template

**Private Overlay**:
Configuration or bootstrap material that is needed by Brandon but should not be public. It may be stored separately and encrypted, but it is not a dumping ground for arbitrary machine state.
_Avoid_: Private repo, secret repo, local hacks

**Machine Role**:
A coarse classification of a machine using independent choices such as work or personal, and desktop or non-desktop. It is not a named profile or hostname-specific identity.
_Avoid_: Profile, environment, machine type

**Forbidden Material**:
Any value, path, hostname, address, token, or internal detail that should not appear in the Shareable Base.
_Avoid_: Private stuff, sensitive bits

**Secret Inventory**:
The set of named secrets and secret-backed environment variables needed by Brandon's tools. The inventory belongs in the Private Overlay, even when the values are retrieved through a secret manager.
_Avoid_: Public secret list, token exports

**Secret Abstraction**:
The stable interface shell helpers use to retrieve secrets without caring which backend stores them. The chosen Secret Abstraction is fnox; provider choice can vary behind the Private Overlay.
_Avoid_: Direct password-manager calls, backend-specific shell config

**Secret Tooling**:
Public-safe tooling needed to use the Secret Abstraction, such as the fnox CLI. Secret Tooling may be installed by the Shareable Base, preferably through mise when available and through an idempotent chezmoi script otherwise; secret names, providers, keys, and values belong outside it.
_Avoid_: Secret config, private provider setup

**Secret Configuration**:
The fnox configuration, provider setup, secret names, key paths, and backend-specific settings needed to retrieve secrets. Secret Configuration belongs entirely in the Private Overlay or unmanaged local files, not in the Shareable Base.
_Avoid_: Public fnox.toml, public secret skeleton

**Secret Environment**:
The optional shell environment loaded from private or unmanaged local files when secrets are needed. The Shareable Base may source `${XDG_CONFIG_HOME:-$HOME/.config}/zsh/private.zsh` if present, but should not run fnox activation directly.
_Avoid_: Base fnox activation, global token exports

**XDG Path Preference**:
The preference to use XDG locations for managed configuration, local/private configuration, cache, and state when the underlying tool supports it cleanly. Shell startup should set default XDG variables early without overriding existing values; this preference should not force nonstandard paths onto tools that expect conventional locations unless the tool explicitly supports relocation.
_Avoid_: Home directory sprawl, forced relocation

**Zsh Entrypoint**:
The conventional `~/.zshrc` file read by zsh at interactive shell startup. It should remain at the default location, not be relocated with `ZDOTDIR`, and act as a small loader for XDG-managed zsh configuration.
_Avoid_: Full zshrc, ZDOTDIR relocation

**Work-Only Tooling**:
Tooling behavior that is useful only on machines marked as work machines. It may be shared across Linux and macOS work machines, but should not be installed or sourced on personal machines.
_Avoid_: Work profile, company config

**Helper Module**:
A focused `.zsh` file under `${XDG_CONFIG_HOME:-$HOME/.config}/zsh/helpers/` that groups related shell functions, aliases, or environment setup. Helper Modules are organized by capability, not by machine role; chezmoi decides which modules are installed or sourced for each machine.
_Avoid_: Shell blob, zshrc section

**Selective Installation**:
The rule that files for role-specific behavior should not be installed on machines that do not use that role. Work-only Helper Modules should be absent from personal machines, not merely disabled at runtime.
_Avoid_: Source gating, dormant config

**Helper Manifest**:
A generated `${XDG_CONFIG_HOME:-$HOME/.config}/zsh/helpers.zsh` file that sources the Helper Modules selected for a machine. `.zshrc` should source the Helper Manifest instead of listing every module directly.
_Avoid_: Helper glob, inline source list

**Prompt Stack**:
The managed Zsh framework and prompt modules that provide shell prompt, completions, suggestions, and highlighting on all supported Linux and macOS machines. The chosen Prompt Stack is zimfw with Pure plus a small set of zsh-users modules, using XDG paths for zimfw configuration and data.
_Avoid_: Starship, powerlevel10k, CachyOS prompt
