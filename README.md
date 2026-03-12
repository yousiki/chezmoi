# chezmoi dotfiles

This repository is the source state for managing my macOS and Linux
configuration with `chezmoi`.

It is initialized as a cross-platform baseline with:

- repo-only documentation that is ignored by `chezmoi`
- a Homebrew-first workflow for macOS package management
- Codex agent guidance for future edits

## Principles

- Keep the source state readable and predictable.
- Prefer simple `dot_*`, `private_*`, `executable_*`, and `run_*` conventions
  over clever templating.
- Use templates only for true cross-platform or host-specific differences.
- Keep secrets encrypted or in `private_*` files. Never commit plaintext
  secrets.
- Use `Brewfile` as the source of truth for macOS packages.

## Repository layout

```text
.
├── .chezmoiscripts/           # Scripts executed by chezmoi, not deployed to $HOME
├── dot_config/homebrew/Brewfile
├── .chezmoiignore             # Prevent repo-only files from deploying to $HOME
├── .gitignore
├── AGENTS.md                  # Instructions for coding agents working here
└── README.md
```

As you add managed files, use normal chezmoi source names such as:

- `dot_zshrc`
- `dot_config/nvim/init.lua`
- `private_dot_ssh/config`
- `run_once_before_10-install-packages.sh.tmpl`
- `run_onchange_after_20-refresh-tools.sh`

## Suggested workflow

Initialize or inspect:

```sh
chezmoi doctor
chezmoi status
chezmoi diff
```

Add existing files:

```sh
chezmoi add ~/.zshrc
chezmoi add ~/.config/git/config
```

Preview changes before applying:

```sh
chezmoi diff
chezmoi apply --dry-run --verbose
chezmoi apply --verbose
```

Work inside the source repo:

```sh
chezmoi cd
```

## Package management

### macOS

macOS packages are managed with a Homebrew `Brewfile`.

- [dot_config/homebrew/Brewfile](/Users/yousiki/.local/share/chezmoi/dot_config/homebrew/Brewfile)
  is the source of truth.
- [`.chezmoiscripts/run_once_before_00-install-homebrew.sh.tmpl`](/Users/yousiki/.local/share/chezmoi/.chezmoiscripts/run_once_before_00-install-homebrew.sh.tmpl)
  bootstraps Homebrew if needed.
- [`.chezmoiscripts/run_onchange_before_10-brew-bundle.sh.tmpl`](/Users/yousiki/.local/share/chezmoi/.chezmoiscripts/run_onchange_before_10-brew-bundle.sh.tmpl)
  applies the `Brewfile` on macOS when the package list changes.

Useful commands:

```sh
brew bundle --file ~/.config/homebrew/Brewfile
brew bundle dump --force --describe --file ~/.config/homebrew/Brewfile
```

### Linux

Linux package management is intentionally left open for now. Add apt, dnf, or
another distro-specific flow once you decide how you want to standardize it.

Scripts that should run during `chezmoi apply` live under
[`.chezmoiscripts/`](/Users/yousiki/.local/share/chezmoi/.chezmoiscripts). This
is a special chezmoi directory: files in it are treated as normal `run_*`
scripts without creating a `.chezmoiscripts` directory in `$HOME`.

## Cross-platform guidance

- Prefer separate files when the config is substantially different per OS.
- Prefer small template branches when only a few lines differ.
- Gate platform-specific content with `.chezmoi.os` and host-specific content
  with `.chezmoi.hostname`.

Example:

```gotmpl
{{- if eq .chezmoi.os "darwin" -}}
set -g default-command /opt/homebrew/bin/zsh
{{- else if eq .chezmoi.os "linux" -}}
set -g default-command /usr/bin/zsh
{{- end -}}
```

## What to add next

Good first targets for a fresh dotfiles repo:

- `git`, `zsh`, `tmux`, and shell aliases
- editor config such as Neovim, Helix, or VS Code settings
- `ssh` config using `private_*`
- Linux package bootstrap scripts once you choose apt, dnf, or another standard
- host-specific overrides for workstations, laptops, and servers

## Codex support

- [AGENTS.md](/Users/yousiki/.local/share/chezmoi/AGENTS.md) defines how agents
  should work in this repo.
