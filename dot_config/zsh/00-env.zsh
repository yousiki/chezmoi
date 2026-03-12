typeset -U path PATH fpath FPATH

# Shared environment and cache locations for login and interactive shells.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
export ZSH_COMPDUMP="${ZSH_CACHE_DIR}/zcompdump-${HOST}-${ZSH_VERSION}"
export LESSHISTFILE=-

mkdir -p "$ZSH_CACHE_DIR"

# ~/.zprofile usually initializes Homebrew for login shells. This fallback keeps
# nested interactive shells functional when they do not inherit HOMEBREW_PREFIX.
if [[ -z "${HOMEBREW_PREFIX:-}" ]]; then
  for brew_prefix in /opt/homebrew /home/linuxbrew/.linuxbrew /usr/local; do
    if [[ -x "$brew_prefix/bin/brew" ]]; then
      export HOMEBREW_PREFIX="$brew_prefix"
      path=("$brew_prefix/bin" "$brew_prefix/sbin" $path)
      break
    fi
  done
fi

export PATH
