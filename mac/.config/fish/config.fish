# disable the default greeting
set -g fish_greeting ''

# force 24bit color
set -g fish_term24bit 1

# exports and aliases
if type -q replay
  # run `fisher install` if you don't have replay yet
  test -s "$HOME/.exports" ; and replay "source $HOME/.exports"
  test -s "$HOME/.aliases" ; and source $HOME/.aliases
end

# 1password
if command -v op >/dev/null
  op completion fish | source
end

# nodenv
if command -v nodenv >/dev/null
  source (nodenv init -|psub)
end

# zoxide
if command -v zoxide >/dev/null
  zoxide init fish | source
end
