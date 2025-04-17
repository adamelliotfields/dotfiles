# changes the default shell for the current user
function dotfiles_chsh {
  source "$(dirname "${BASH_SOURCE[0]}")/sudo.sh"

  local shell=${1:-/bin/bash}

  # add shell to /etc/shells if not already there
  if ! grep -q "$shell" /etc/shells ; then
    echo "$shell" | dotfiles_sudo tee -a /etc/shells >/dev/null
  fi

  # change shell for current user
  chsh -s "$shell"
}
