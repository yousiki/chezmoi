# AGENTS.md

This repository is a `chezmoi` source state for cross-platform macOS and Linux
dotfiles.

## Goals

- Keep the repo safe to apply on both macOS and Linux.
- Keep repo-only files out of the target home directory.
- Prefer maintainable source-state conventions over ad hoc shell scripts.

## Required conventions

- Treat [`.chezmoiignore`](/Users/yousiki/.local/share/chezmoi/.chezmoiignore)
  as part of every repo-doc change. Any repo-only file added at the top level
  must be ignored there unless it is intentionally managed by `chezmoi`.
- Prefer standard chezmoi prefixes: `dot_`, `private_`, `executable_`,
  `run_once_`, `run_onchange_`, `create_`.
- Treat
  [dot_config/homebrew/Brewfile](/Users/yousiki/.local/share/chezmoi/dot_config/homebrew/Brewfile)
  as the source of truth for macOS package management.
- Put `run_*` scripts under
  [`.chezmoiscripts/`](/Users/yousiki/.local/share/chezmoi/.chezmoiscripts)
  instead of the repo root unless there is a specific reason not to.
- Use templates only when they remove meaningful duplication or handle true
  OS/host variation.
- Never commit plaintext secrets. Use encrypted chezmoi files or `private_*`
  plus an external secret manager.
- Avoid machine-local absolute paths unless explicitly gated by OS or hostname
  data.

## Editing rules

- Before adding repo-only docs, update
  [`.chezmoiignore`](/Users/yousiki/.local/share/chezmoi/.chezmoiignore).
- Before adding a script, decide whether it should be `run_once_`,
  `run_onchange_`, or a normal managed executable.
- Prefer
  [`.chezmoiscripts/`](/Users/yousiki/.local/share/chezmoi/.chezmoiscripts) for
  chezmoi lifecycle scripts.
- For macOS package changes, prefer editing
  [dot_config/homebrew/Brewfile](/Users/yousiki/.local/share/chezmoi/dot_config/homebrew/Brewfile)
  over inventing custom package lists.
- Before adding a template, prefer a plain file if the file does not actually
  vary by machine.
- For major OS differences, prefer separate source files or directories over
  dense inline branching.

## Validation

After meaningful changes, prefer these checks:

```sh
chezmoi doctor
chezmoi diff
chezmoi apply --dry-run --verbose
```

For templated files, also use:

```sh
chezmoi execute-template < file.tmpl
```

## Repo map

- [README.md](/Users/yousiki/.local/share/chezmoi/README.md): human-facing
  overview and workflow
- [`.chezmoiscripts/`](/Users/yousiki/.local/share/chezmoi/.chezmoiscripts):
  lifecycle scripts run by chezmoi
- [dot_config/homebrew/Brewfile](/Users/yousiki/.local/share/chezmoi/dot_config/homebrew/Brewfile):
  macOS package source of truth
