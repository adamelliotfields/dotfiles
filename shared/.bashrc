# shellcheck shell=bash
HOME="${HOME:?}"

# exports and aliases
[ -s "${HOME}/.exports" ] && source "${HOME}/.exports"
[ -s "${HOME}/.aliases" ] && source "${HOME}/.aliases"

# nodenv
if command -v nodenv >/dev/null ; then
  eval "$(nodenv init - --no-rehash bash)"
fi

# nvm
unset NVM_DIR
[[ -d /usr/local/share/nvm ]] && export NVM_DIR='/usr/local}/share/nvm'
[[ -z $NVM_DIR && -d ${HOME}/.nvm ]] && export NVM_DIR="${HOME}/.nvm"
[[ -n $NVM_DIR && -s ${NVM_DIR}/nvm.sh ]] && source "${NVM_DIR}/nvm.sh"

# if interactive
# don't load completions as they slow down the prompt and we rarely use Bash interactively
if [[ $- =~ i ]] ; then
  # update window size after each command
  shopt -s checkwinsize

  # don't overwrite the history file
  shopt -s histappend

  # ignore duplicates and lines starting with space
  HISTCONTROL=ignoreboth

  # history size
  HISTSIZE=1000
  HISTFILESIZE=1000

  # zoxide
  if command -v zoxide >/dev/null ; then
    eval "$(zoxide init bash)"
  fi

  # prompt last
  [[ -n $HOMEBREW_PREFIX && -s "${HOMEBREW_PREFIX:-/usr/local}/share/liquidprompt" ]] && source "${HOMEBREW_PREFIX:-/usr/local}/share/liquidprompt"
  [[ -z $HOMEBREW_PREFIX && -s "${HOME}/.liquidprompt/liquidprompt" ]] && source "${HOME}/.liquidprompt/liquidprompt"
fi

# inc
[ -s "${HOME}/.bashrc.inc" ] && source "${HOME}/.bashrc.inc"
