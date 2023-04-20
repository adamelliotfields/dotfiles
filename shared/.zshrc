# shellcheck shell=zsh
# ignore duplicates and lines starting with space
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

# don't overwrite the history file
setopt APPEND_HISTORY

# history size
HISTSIZE=1000
SAVEHIST=1000

# prevent percentage showing up if output doesn't end with a newline
PROMPT_EOL_MARK=''

# zsh anonymous functions are immediately executed
() {
  local home="${HOME:?}"

  # exports and aliases
  [ -s "${home}/.exports" ] && source "${home}/.exports"
  [ -s "${home}/.aliases" ] && source "${home}/.aliases"

  local prefix="${HOMEBREW_PREFIX:-/usr/local}"
  local zsh_site_functions="${prefix}/share/zsh/site-functions"
  local zsh_pure="${home}/.pure"
  local fzf_completion_zsh="${prefix}/opt/fzf/shell/completion.zsh"
  local gcloud_completion_zsh="${CLOUDSDK_HOME:-/usr/local/google-cloud-sdk}/completion.zsh.inc"

  # set fpath before loading functions
  if [[ $fpath[(I)$zsh_site_functions] -eq 0 ]] ; then
    fpath+=("$zsh_site_functions")
  fi

  if [[ -d $zsh_pure && $fpath[(I)$zsh_pure] -eq 0 ]] ; then
    fpath+=("$zsh_pure")
  fi

  # load functions
  [ $+functions[compdef] -eq 0 ] && autoload -Uz compinit ; compinit
  [ $+functions[complete] -eq 0 ] && autoload -Uz bashcompinit ; bashcompinit
  [ $+functions[prompt] -eq 0 ] && autoload -Uz promptinit ; promptinit

  # 1password
  if command -v op >/dev/null ; then
    eval "$(op completion zsh)"
    compdef _op op
  fi

  # fzf
  [ -s "$fzf_completion_zsh" ] && source "$fzf_completion_zsh"

  # gcloud
  [ -s "$gcloud_completion_zsh" ] && source "$gcloud_completion_zsh"

  # nodenv
  if command -v nodenv >/dev/null ; then
    eval "$(nodenv init - --no-rehash zsh)"
  fi

  # nvm
  unset NVM_DIR
  [[ -d ${prefix}/share/nvm ]] && export NVM_DIR="${prefix}/share/nvm"
  [[ -z $NVM_DIR && -d ${home}/.nvm ]] && export NVM_DIR="${home}/.nvm"
  [[ -n $NVM_DIR && -s ${NVM_DIR}/nvm.sh ]] && source "${NVM_DIR}/nvm.sh"

  # vault
  if command -v vault >/dev/null ; then
    complete -o nospace -C vault vault
  fi

  # zoxide
  if command -v zoxide >/dev/null ; then
    eval "$(zoxide init zsh)"
  fi

  # prompt
  prompt pure
}
