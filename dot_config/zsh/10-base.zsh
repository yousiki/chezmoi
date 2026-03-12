typeset -U path PATH fpath FPATH

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
export ZSH_COMPDUMP="${ZSH_CACHE_DIR}/zcompdump-${HOST}-${ZSH_VERSION}"
export LESSHISTFILE=-

mkdir -p "$ZSH_CACHE_DIR" "$ZSH_CACHE_DIR/completion"

setopt auto_cd
setopt auto_menu
setopt complete_in_word
setopt no_beep
setopt prompt_subst
setopt pushdminus

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt inc_append_history
