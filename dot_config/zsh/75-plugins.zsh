# zinit plugins are grouped by startup sensitivity.
if ! command -v zinit >/dev/null 2>&1; then
  return
fi

# Completion UI must load after compinit but before widget-wrapping plugins.
zinit ice lucid
zinit light Aloxaf/fzf-tab

# Core editor feedback should be available as soon as the shell is interactive.
zinit ice lucid
zinit light zsh-users/zsh-autosuggestions

# Keep syntax highlighting last among immediate plugins so it sees the final widget stack.
zinit ice lucid
zinit light zdharma-continuum/fast-syntax-highlighting

# Interactive extras are deferred to preserve first-prompt latency.
zinit ice wait'0' lucid
zinit snippet https://github.com/junegunn/fzf-git.sh/blob/main/fzf-git.sh

zinit ice wait'0' lucid
zinit snippet OMZP::eza

# OMZ snippets are useful but non-essential during initial shell startup.
zinit ice wait'0' lucid
zinit snippet OMZP::git

zinit ice wait'0' lucid
zinit snippet OMZP::extract

zinit ice wait'0' lucid
zinit snippet OMZP::sudo

zinit ice wait'0' lucid
zinit snippet OMZP::command-not-found

zinit ice wait'0' lucid
zinit snippet OMZP::copypath

zinit ice wait'0' lucid
zinit snippet OMZP::copyfile

zinit ice wait'0' lucid
zinit snippet OMZP::web-search

zinit ice wait'0' lucid
zinit snippet OMZP::jsontools

zinit ice wait'0' lucid
zinit snippet OMZP::bun

# McFly must bind Ctrl-R after every other widget provider.
if [[ -t 0 && -t 1 ]] && command -v mcfly >/dev/null 2>&1; then
  eval "$(mcfly init zsh)"
fi
