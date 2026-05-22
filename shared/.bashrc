# shellcheck shell=bash
set +o posix

# update window size after each command
shopt -s checkwinsize

# don't overwrite the history file
shopt -s histappend

# ignore duplicates and lines starting with space
HISTCONTROL=ignoreboth

# history size
HISTSIZE=1000
HISTFILESIZE=1000

# sources
[ -s "${HOME}/.exports" ] && source "${HOME}/.exports"
[ -s "${HOME}/.secrets" ] && source "${HOME}/.secrets"
[ -s "${HOME}/.aliases" ] && source "${HOME}/.aliases"

# completions
if [[ -r "${HOMEBREW_PREFIX:-/usr/local}/etc/profile.d/bash_completion.sh" ]]; then
  source "${HOMEBREW_PREFIX:-/usr/local}/etc/profile.d/bash_completion.sh"
elif [[ -r "${HOMEBREW_PREFIX:-/usr/local}/etc/bash_completion" ]]; then
  source "${HOMEBREW_PREFIX:-/usr/local}/etc/bash_completion"
elif [[ -r /usr/share/bash-completion/bash_completion ]]; then
  source /usr/share/bash-completion/bash_completion
elif [[ -r /etc/bash_completion ]]; then
  source /etc/bash_completion
fi

# zoxide
[[ -n $(command -v zoxide 2>/dev/null) ]] && eval "$(zoxide init bash)"
