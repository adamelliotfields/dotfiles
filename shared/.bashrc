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
completions_dir=''
[[ -d "${HOMEBREW_PREFIX:-/usr/local}/etc/bash_completion.d" ]] && completions_dir="${HOMEBREW_PREFIX:-/usr/local}/etc/bash_completion.d"
[[ -z $completions_dir && -d /etc/bash_completion.d ]] && completions_dir='/etc/bash_completion.d'
[[ -n $completions_dir ]] && for file in "${completions_dir}"/* ; do [[ -s $file ]] && source "$file" ; done
unset completions_dir

# pyenv
[[ -n $(command -v pyenv 2>/dev/null) ]] && eval "$(pyenv init -)"

# nvm
unset NVM_DIR
[[ -d /usr/local/share/nvm ]] && export NVM_DIR='/usr/local/share/nvm'
[[ -z $NVM_DIR && -d ${HOME}/.nvm ]] && export NVM_DIR="${HOME}/.nvm"
[[ -n $NVM_DIR && -s ${NVM_DIR}/nvm.sh ]] && source "${NVM_DIR}/nvm.sh"

# prompt last
[[ -n $HOMEBREW_PREFIX && -s "${HOMEBREW_PREFIX}/share/liquidprompt" ]] && source "${HOMEBREW_PREFIX}/share/liquidprompt"
[[ -z $HOMEBREW_PREFIX && -s "${HOME}/.liquidprompt/liquidprompt" ]] && source "${HOME}/.liquidprompt/liquidprompt"
