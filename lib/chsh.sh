# changes the default shell for the current user
function dotfiles_chsh {
  # run as sudo if not root
  function _sudo {
    [[ $EUID -ne 0 ]] && sudo "$@" || "$@"
  }

  local shell=${1:-/bin/bash}

  # add shell to /etc/shells if not already there
  if ! grep -q "$shell" /etc/shells ; then
    echo "$shell" | _sudo tee -a /etc/shells >/dev/null
  fi

  # change shell for current user
  chsh -s "$shell"
}
