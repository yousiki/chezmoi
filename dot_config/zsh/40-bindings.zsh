# Base editor keymap and terminal-specific fixes.
bindkey -e
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[f' forward-word
bindkey '^[b' backward-word

if [[ -n "${terminfo[khome]:-}" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line
fi

if [[ -n "${terminfo[kend]:-}" ]]; then
  bindkey "${terminfo[kend]}" end-of-line
fi
