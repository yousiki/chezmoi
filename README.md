# chezmoi dotfiles

This repository is the `chezmoi` source state for my macOS and Linux
dotfiles. It is a configuration repo, not an application repo: the goal is to
keep the rendered home directory predictable, cross-platform, and safe to apply
with `chezmoi`.

## Principles

- Keep managed files small, readable, and idempotent.
- Prefer standard `chezmoi` names such as `dot_*`, `private_*`,
  `executable_*`, `run_once_*`, and `run_onchange_*`.
- Use templates only for real OS-specific or host-specific differences.
- Keep repo-only files ignored by `chezmoi`.
- Keep secrets out of tracked plaintext. Use `private_*` for private file modes,
  and keep machine-local values in local include files when possible.

## Repository layout

```text
.
├── .chezmoiexternal.toml      # External Catppuccin themes fetched by chezmoi
├── .chezmoiignore             # Repo-only and platform-specific deploy ignores
├── .chezmoiscripts/           # Lifecycle scripts run by chezmoi
├── dot_claude/                # Claude Code settings, docs, and hooks
├── dot_config/
│   ├── bat/                   # bat config
│   ├── btop/                  # btop config
│   ├── cmux/                  # cmux settings
│   ├── ghostty/               # Ghostty terminal config
│   ├── git/                   # Global git ignore template
│   ├── gitui/                 # gitui theme selection
│   ├── homebrew/Brewfile      # macOS package source of truth
│   ├── opencode/              # OpenCode config, TUI theme, and agent config
│   ├── private_tokscale/      # Linux Tokscale settings
│   ├── starship.toml          # Starship prompt config
│   ├── zellij/                # Zellij config
│   └── zsh/                   # Ordered zsh fragments, zimrc, and modules
├── dot_gitconfig.tmpl         # OS-aware git credential helper and local include
├── dot_zprofile               # Login-shell environment setup
├── dot_zshrc                  # Interactive zsh entrypoint
├── private_Library/           # macOS private application settings
├── AGENTS.md                  # Agent instructions for this repo
└── README.md
```

## Shell setup

`dot_zprofile` handles login-shell setup:

- prepends `~/.local/bin`
- initializes Homebrew with `brew shellenv` when `brew` is available
- sources OrbStack's shell integration if present

`dot_zshrc` only runs for interactive shells. It sets `ZSH_CONFIG_DIR` and then
loads these files in order:

1. `dot_config/zsh/10-base.zsh` sets XDG paths, zsh cache paths, history, and
   core shell options.
2. `dot_config/zsh/15-agent-cli.zsh` exports agent CLI environment toggles.
3. `dot_config/zsh/20-zim.zsh` initializes Zim from Homebrew or `~/.zim` and
   sources the generated `init.zsh` when available.
4. `dot_config/zsh/30-local.zsh` adds optional local aliases and integrations
   only when their commands or files exist.

The Zim module list lives in `dot_config/zsh/zimrc`. Local modules under
`dot_config/zsh/modules/bun` and `dot_config/zsh/modules/npm` set tool-specific
paths and cache generated completions under the zsh cache directory.

## Package management

### macOS

macOS packages are managed with Homebrew.

- [dot_config/homebrew/Brewfile](dot_config/homebrew/Brewfile) is the package
  source of truth.
- [`.chezmoiscripts/run_onchange_before_10-brew-bundle.sh.tmpl`](.chezmoiscripts/run_onchange_before_10-brew-bundle.sh.tmpl)
  runs `brew bundle` on macOS when the managed package list changes.

Useful commands:

```sh
brew bundle --file ~/.config/homebrew/Brewfile
brew bundle dump --force --describe --file ~/.config/homebrew/Brewfile
```

### Linux

Linux package management is not standardized in this repo yet. Managed Linux
config is still supported through templates and platform-specific files, but
there is no apt, dnf, pacman, or other distro package bootstrap script.

## Lifecycle scripts

Lifecycle scripts live in [`.chezmoiscripts/`](.chezmoiscripts). Chezmoi treats
files in this directory as normal `run_*` scripts without creating a
`.chezmoiscripts` directory in `$HOME`.

- `run_onchange_before_10-brew-bundle.sh.tmpl` applies the Brewfile on macOS and
  exits without changes on other platforms.
- `run_onchange_after_20-zim-install.sh.tmpl` runs `zimfw install` and
  `zimfw build` when `dot_config/zsh/zimrc` changes and Zim is available.

## Git config

`dot_gitconfig.tmpl` configures:

- GitHub and gist credential helpers through `gh auth git-credential`, using the
  Homebrew path on macOS and `/usr/bin/gh` on Linux.
- `init.defaultBranch = main`.
- `include.path = ~/.gitconfig.local` for machine-local identity and overrides.

Keep personal identity out of this source repo. A local file such as
`~/.gitconfig.local` can hold:

```gitconfig
[user]
	name = Your Name
	email = your-email
```

`dot_config/git/ignore.tmpl` renders the global git ignore file with common
editor patterns plus macOS- or Linux-specific ignores.

## Tools and themes

Managed terminal and CLI config currently includes Ghostty, bat, btop, gitui,
Starship, Zellij, cmux, OpenCode, Claude Code, and Tokscale.

`.chezmoiexternal.toml` fetches Catppuccin theme assets for bat, btop, gitui,
and yazi on a weekly refresh period. Source files select or configure those
themes where needed, for example `dot_config/bat/config`,
`dot_config/gitui/symlink_theme.ron`, and `dot_config/starship.toml`.

## Agent and editor config

- `dot_claude/` contains Claude Code settings, RTK notes, and hooks for RTK
  command rewriting and nono sandbox diagnostics.
- `dot_config/opencode/` contains OpenCode config, MCP entries, LSP commands,
  formatter commands, TUI theme selection, and oh-my-openagent configuration.

These files configure local tools. They are not a repo build system.

## Platform-specific files

Tokscale settings are managed in both known platform locations:

- macOS:
  `private_Library/private_Application Support/tokscale/settings.json.tmpl`
- Linux: `dot_config/private_tokscale/settings.json.tmpl`

`.chezmoiignore` prevents the non-matching platform path from being deployed.
It also keeps repo-only files such as `README.md`, `AGENTS.md`, `.gitignore`,
and local agent metadata out of the target home directory.

## Workflow

Inspect the local environment and rendered changes:

```sh
chezmoi doctor
chezmoi status
chezmoi diff
```

Preview before applying:

```sh
chezmoi apply --dry-run --verbose
```

Apply intentionally:

```sh
chezmoi apply --verbose
```

Work inside the source repo:

```sh
chezmoi cd
```

Add managed files with normal chezmoi source names:

```sh
chezmoi add ~/.zshrc
chezmoi add ~/.config/git/config
```

## Validation and formatting

This repo has no conventional build or test runner. Use the narrowest real
check for the file you changed.

Core checks:

```sh
chezmoi doctor
chezmoi status
chezmoi diff
chezmoi apply --dry-run --verbose
```

Template rendering:

```sh
chezmoi execute-template < path/to/file.tmpl
```

Formatting:

```sh
shfmt -w -i 2 -ci <file>
taplo format <file>
prettier --write <file>
```

Shell uses `shfmt`, TOML uses `taplo`, and Markdown uses `prettier`.
