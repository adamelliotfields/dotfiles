# disable the default greeting
set -g fish_greeting ''

# force 24bit color
set -g fish_term24bit 1

# run `fisher update` if you don't have replay yet
if type -q replay
  test -s "$HOME/.exports" && replay "source $HOME/.exports"
  test -s "$HOME/.secrets" && replay "source $HOME/.secrets"
  test -s "$HOME/.aliases" && source "$HOME/.aliases"

  # nvm
  # only source if a node version is installed
  set -gx NVM_DIR $HOME/.nvm
  if test -n "$(ls $NVM_DIR/versions/node 2>/dev/null)"
    replay "source $NVM_DIR/nvm.sh"
  end
end

# personal functions
type -q chat && chat --completions | source
type -q gituser && gituser --completions | source
type -q up && up --completions | source

# pyenv
if command -v pyenv >/dev/null
  pyenv init - | source
end

# 1password
if command -v op >/dev/null
  op completion fish | source
end

# zoxide
if command -v zoxide >/dev/null
  zoxide init fish | source
end
