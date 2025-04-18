# disable the default greeting
set -g fish_greeting ''

# force 24bit color
set -g fish_term24bit 1

# run `fisher update` if you don't have replay yet
if type -q replay
  test -s "$HOME/.exports" && replay "source $HOME/.exports"
  test -s "$HOME/.secrets" && replay "source $HOME/.secrets"
  test -s "$HOME/.aliases" && replay "source $HOME/.aliases"
end

# fnm
if command -v fnm >/dev/null
  fnm env --use-on-cd --version-file-strategy=recursive --shell=fish | source
end

# pyenv
if command -v pyenv >/dev/null
  pyenv init - | source
end

# zoxide
if command -v zoxide >/dev/null
  zoxide init fish | source
end
