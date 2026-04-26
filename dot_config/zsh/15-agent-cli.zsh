# OpenCode
export OPENCODE_DISABLE_LSP_DOWNLOAD=true

# Route `claude` through ccs when available
if command -v ccs >/dev/null 2>&1; then
  alias claude='ccs'
fi
