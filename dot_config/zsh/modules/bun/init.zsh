export BUN_INSTALL="$HOME/.cache/bun"

# Remove legacy Bun install locations from inherited PATH before adding the managed one.
path=("${(@)path:#$HOME/.bun/bin}")
path=("${(@)path:#$HOME/.cache/.bun/bin}")
[[ -d "${BUN_INSTALL}/bin" ]] && path=("${BUN_INSTALL}/bin" $path)
