export ZIM_CONFIG_FILE="${ZSH_CONFIG_DIR}/zimrc"
export ZIM_HOME="${HOME}/.zim"

zimfw_script=

if command -v brew >/dev/null 2>&1; then
  brew_prefix="$(brew --prefix 2>/dev/null)"
  [[ -n "$brew_prefix" ]] && zimfw_script="${brew_prefix}/opt/zimfw/share/zimfw.zsh"
elif [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  zimfw_script="${HOMEBREW_PREFIX}/opt/zimfw/share/zimfw.zsh"
fi

if [[ -r "$zimfw_script" && -r "$ZIM_CONFIG_FILE" && (! -r "${ZIM_HOME}/init.zsh" || "${ZIM_HOME}/init.zsh" -ot "$ZIM_CONFIG_FILE") ]]; then
  source "$zimfw_script" init -q
fi

if [[ -r "${ZIM_HOME}/init.zsh" ]]; then
  source "${ZIM_HOME}/init.zsh"
fi

unset brew_prefix
unset zimfw_script
