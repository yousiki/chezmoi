# Bootstrap zinit separately from plugin declarations so startup phases stay readable.
if [[ -z "${HOMEBREW_PREFIX:-}" ]]; then
  return
fi

if [[ ! -r "${HOMEBREW_PREFIX}/opt/zinit/zinit.zsh" ]]; then
  return
fi

source "${HOMEBREW_PREFIX}/opt/zinit/zinit.zsh"
