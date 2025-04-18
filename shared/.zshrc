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
  # sources
  [ -s "${HOME}/.exports" ] && source "${HOME}/.exports"
  [ -s "${HOME}/.secrets" ] && source "${HOME}/.secrets"
  [ -s "${HOME}/.aliases" ] && source "${HOME}/.aliases"

  local zsh_site_functions="${prefix}/share/zsh/site-functions"

  # set fpath before loading functions
  [[ $fpath[(I)$zsh_site_functions] -eq 0 ]] && fpath+=("$zsh_site_functions")

  # load functions
  [ $+functions[compdef] -eq 0 ] && autoload -Uz compinit ; compinit
  [ $+functions[complete] -eq 0 ] && autoload -Uz bashcompinit ; bashcompinit

  # pyenv
  [[ -n $(command -v pyenv 2>/dev/null) ]] && eval "$(pyenv init -)"

  # fnm
  [[ -n $(command -v fnm 2>/dev/null) ]] && eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell=zsh)"

  # zoxide
  [[ -n $(command -v zoxide 2>/dev/null) ]] && eval "$(zoxide init zsh)"
}
