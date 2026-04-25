# OpenCode
export OPENCODE_DISABLE_LSP_DOWNLOAD=true

# Claude Code
export CLAUDE_CODE_NO_FLICKER=1

# Run `cmux claude-teams` under a chosen ccs profile.
# Usage: ccs-cmux <profile> [claude-args...]
ccs-cmux() {
  emulate -L zsh
  if (($# < 1)) || [[ "$1" == -h || "$1" == --help ]]; then
    print "usage: ccs-cmux <profile> [claude-args...]"
    print "  Run 'cmux claude-teams' under the env of a ccs profile."
    print "  Profiles come from 'ccs auth list' or 'ccs' (api/cliproxy)."
    (($# < 1)) && return 2
    return 0
  fi
  if ! command -v ccs >/dev/null 2>&1 || ! command -v cmux >/dev/null 2>&1; then
    print -u2 "ccs-cmux: requires both ccs and cmux on PATH"
    return 127
  fi
  local profile="$1"
  shift
  local exports
  exports=$(ccs env "$profile" --format raw 2>/dev/null) || {
    print -u2 "ccs-cmux: 'ccs env $profile' failed"
    return 1
  }
  if [[ "${exports## }" != export\ * ]]; then
    print -u2 "ccs-cmux: 'ccs env $profile --format raw' produced no env exports"
    return 1
  fi
  (eval "$exports" && exec cmux claude-teams "$@")
}
