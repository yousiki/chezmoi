# Set npm prefix to avoid needing sudo for global installs.
export NPM_CONFIG_PREFIX="${NPM_CONFIG_PREFIX:-$HOME/.npm-global}"

# Add npm global bin to path.
[[ -d "${NPM_CONFIG_PREFIX}/bin" ]] && path=("${NPM_CONFIG_PREFIX}/bin" $path)
