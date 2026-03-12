if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

if command -v gdu-go >/dev/null 2>&1; then
  alias gdu='gdu-go'
fi

if [[ -t 0 && -t 1 ]] && command -v mcfly >/dev/null 2>&1; then
  eval "$(mcfly init zsh)"
fi
