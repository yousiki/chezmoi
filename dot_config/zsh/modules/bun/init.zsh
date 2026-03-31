export BUN_INSTALL="${BUN_INSTALL:-$HOME/.cache/.bun}"

# Newer bun uses $BUN_INSTALL/bin; older versions default to ~/.bun/bin.
[[ -d "$HOME/.bun/bin" ]] && path=("$HOME/.bun/bin" $path)
[[ -d "${BUN_INSTALL}/bin" ]] && path=("${BUN_INSTALL}/bin" $path)
