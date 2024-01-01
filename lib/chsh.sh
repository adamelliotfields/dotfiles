#!/usr/bin/env bash
# changes the default shell for the current user
function dotfiles_chsh {
  local shell=${1:-/bin/bash}

  # add shell to /etc/shells if not already there
  if ! grep -q "$shell" /etc/shells ; then
    echo "$shell" | sudo tee -a /etc/shells >/dev/null
  fi

  # change shell for current user
  chsh -s "$shell"
}

# if not sourced
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
  dotfiles_chsh "$@"
fi
