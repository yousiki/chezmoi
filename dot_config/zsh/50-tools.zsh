# fzf shares one themed option string; append feature flags only once per shell.
if [[ "${FZF_DEFAULT_OPTS:-}" != *"--color=bg+:#313244,bg:#1E1E2E"* ]]; then
  export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+${FZF_DEFAULT_OPTS} }--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 --color=selected-bg:#45475A --color=border:#6C7086,label:#CDD6F4"
fi

if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --strip-cwd-prefix --exclude .git'
fi

if command -v bat >/dev/null 2>&1 && command -v eza >/dev/null 2>&1; then
  if [[ "${FZF_DEFAULT_OPTS:-}" != *"--preview='if [[ -d {} ]]; then eza --all --color=always --group-directories-first --icons=always {}; else bat --color=always --style=plain --line-range=:200 {}; fi'"* ]]; then
    export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+${FZF_DEFAULT_OPTS} }--height=45% --layout=reverse --border --inline-info --preview='if [[ -d {} ]]; then eza --all --color=always --group-directories-first --icons=always {}; else bat --color=always --style=plain --line-range=:200 {}; fi'"
  fi
elif command -v bat >/dev/null 2>&1; then
  if [[ "${FZF_DEFAULT_OPTS:-}" != *"--preview='bat --color=always --style=plain --line-range=:200 {}'"* ]]; then
    export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+${FZF_DEFAULT_OPTS} }--height=45% --layout=reverse --border --inline-info --preview='bat --color=always --style=plain --line-range=:200 {}'"
  fi
fi

# Interactive helper integrations belong after shell options, history, and bindings.
if [[ -t 0 && -t 1 ]] && command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
fi
