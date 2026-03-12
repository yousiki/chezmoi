if ! command -v eza >/dev/null 2>&1; then
  alias ll='ls -lh'
  alias la='ls -lah'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

if command -v gdu-go >/dev/null 2>&1; then
  alias gdu='gdu-go'
fi

if grep --color=auto "" /dev/null >/dev/null 2>&1; then
  alias grep='grep --color=auto'
fi

mkcd() {
  mkdir -p -- "$1" && builtin cd -- "$1"
}

take() {
  mkcd "$1"
}
