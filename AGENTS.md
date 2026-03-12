# AGENTS.md

This repository is a `chezmoi` source state for cross-platform macOS and Linux dotfiles. Treat it as a configuration repo, not an application repo.

## Purpose

- Keep the source state safe to apply on both macOS and Linux.
- Keep repo-only files out of the target home directory.
- Prefer standard `chezmoi` conventions over custom automation.
- Make small, predictable changes that preserve idempotent `chezmoi apply`.

## Sources of truth

- Agent instructions: `AGENTS.md`
- Human workflow and repo map: `README.md`
- Repo-only exclusions: `.chezmoiignore`
- Formatting rules: `treefmt.toml`
- macOS packages: `dot_config/homebrew/Brewfile`
- Lifecycle scripts: `.chezmoiscripts/`

## Extra rule files

- No `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md` file was found.
- Do not mention Cursor or Copilot-specific rules as if they exist.

## Repo shape

- `dot_zshrc` is the interactive zsh entrypoint.
- `dot_zprofile` handles login-shell environment setup.
- `dot_config/zsh/10-base.zsh`, `20-zim.zsh`, and `30-local.zsh` load in numeric order.
- `.chezmoiscripts/run_onchange_before_10-brew-bundle.sh.tmpl` is the only current lifecycle script.
- `dot_config/opencode/` contains local editor/OpenCode integration config, not a repo build system.

## Build, lint, test, and validation

This repo does not define a conventional build, lint, or test pipeline. Use the real commands documented in the repo or implied by config files.

### Core validation

```sh
chezmoi doctor
chezmoi status
chezmoi diff
chezmoi apply --dry-run --verbose
```

- Use `chezmoi doctor` to check the local environment.
- Use `chezmoi diff` to inspect rendered changes before and after edits.
- Use `chezmoi apply --dry-run --verbose` before any real apply.
- Use `chezmoi apply --verbose` only when you intentionally want to update the machine.

### Template validation

```sh
chezmoi execute-template < path/to/file.tmpl
```

- Run this when you change template conditionals, includes, or branching.

### Formatting

```sh
treefmt
shfmt -w -i 2 -ci <file>
taplo format <file>
prettier --write <file>
```

- `treefmt.toml` is the formatter contract.
- Shell uses `shfmt -w -i 2 -ci`, TOML uses `taplo format`, and Markdown uses `prettier --write`.
- `prettier`, `shfmt`, `taplo`, and `treefmt` are installed via `dot_config/homebrew/Brewfile`.

### Package management

```sh
brew bundle --file ~/.config/homebrew/Brewfile
brew bundle dump --force --describe --file ~/.config/homebrew/Brewfile
```

- `dot_config/homebrew/Brewfile` is the source of truth for macOS packages.
- Prefer editing the Brewfile over inventing parallel package lists.
- The `run_onchange_before_10-brew-bundle.sh.tmpl` script applies the Brewfile on macOS during `chezmoi apply`.

### Tests and single-test runs

- No automated test suite is currently defined in this repository.
- No single-test command exists because there is no repo-level test runner.
- Do not invent `npm test`, `bun test`, `pytest`, `make test`, or similar commands unless you add the tooling first.
- For verification, use the narrowest real check available: `chezmoi diff`, `chezmoi execute-template`, `treefmt`, or a targeted tool for the file type you changed.

## Code style and editing rules

### Naming and layout

- Use standard `chezmoi` prefixes: `dot_`, `private_`, `executable_`, `run_once_`, `run_onchange_`, and `create_`.
- Keep lifecycle scripts under `.chezmoiscripts/`, not the repo root.
- Preserve numeric ordering for sequenced shell fragments such as `10-base.zsh`, `20-zim.zsh`, and `30-local.zsh`.
- Prefer adding managed files in the exact location and name `chezmoi` expects.

### Formatting and whitespace

- Follow `treefmt.toml` instead of local taste.
- Shell indentation is 2 spaces.
- Keep Markdown and TOML formatted by the configured tools.
- Preserve a clean, minimal style; avoid decorative comments and dense inline explanations.

### File composition and sourcing

- For shell and zsh, prefer small ordered files over one large script.
- Keep login-only environment setup in `dot_zprofile` and interactive behavior in `dot_zshrc` or `dot_config/zsh/*.zsh`.
- Source files conditionally and defensively, as in `dot_zshrc` and `dot_config/zsh/20-zim.zsh`.
- In templates, prefer `include` and small OS branches over large mixed files.

### Variables and naming

- Environment variables are uppercase, for example `XDG_CONFIG_HOME` and `ZSH_CACHE_DIR`.
- Local shell variables use lowercase snake_case, for example `brew_prefix` and `zimfw_script`.
- Quote variable expansions in shell unless unquoted expansion is required.
- Use descriptive names that reflect real machine or tool behavior.

### Language expectations

- Most files here are shell, zsh, TOML, Markdown, JSON, and chezmoi templates.
- There is no TypeScript- or Python-heavy application codebase to optimize for.
- `dot_config/opencode/opencode.json` declares formatter and LSP integrations, but those are editor settings, not repo-wide coding requirements.

### Error handling and safety

- In executable shell scripts, prefer strict mode like `set -eu` when the file should fail fast.
- Guard optional dependencies with `command -v ... >/dev/null 2>&1` before use.
- Prefer early exits on unsupported platforms or missing tools.
- Keep non-critical optional integrations non-fatal when that matches existing patterns, for example `source ... 2>/dev/null || :` in `dot_zprofile`.
- Avoid destructive commands in scripts unless they are clearly justified and idempotent.

### Cross-platform rules

- Keep the repo safe for both `darwin` and `linux`.
- Prefer separate files when OS behavior diverges significantly.
- Prefer small template branches only when they remove real duplication.
- Gate OS-specific logic with `.chezmoi.os` and host-specific logic with `.chezmoi.hostname`.
- Avoid hard-coded machine-local absolute paths unless they are explicitly gated by OS or hostname data.

## Repo-only files and docs

- Treat `.chezmoiignore` as part of every top-level repo-doc change.
- `README.md`, `AGENTS.md`, `treefmt.toml`, `.gitignore`, and similar repo-only files are intentionally ignored by `chezmoi` and should stay that way unless you deliberately want them deployed to `$HOME`.
- Before adding a new top-level repo-only file, update `.chezmoiignore`.

## Things to preserve

- `dot_config/homebrew/Brewfile` remains the macOS package source of truth.
- `.chezmoiscripts/run_onchange_before_10-brew-bundle.sh.tmpl` remains the active package-apply hook.

## Practical review checklist

- Did you keep the change compatible with both macOS and Linux?
- Did you follow `chezmoi` naming conventions instead of inventing new ones?
- Did you update `.chezmoiignore` if you added a repo-only top-level file?
- Did you run the relevant `chezmoi` validation commands?
- Did you format touched files with the configured formatter?
- If you changed a template, did you render it with `chezmoi execute-template`?
