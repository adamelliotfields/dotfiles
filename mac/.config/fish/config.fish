# disable the default greeting
set -g fish_greeting ''

# exports and aliases
if type -q replay
  test -s "$HOME/.exports" ; and replay "source $HOME/.exports"
  test -s "$HOME/.aliases" ; and replay "source $HOME/.aliases"
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
