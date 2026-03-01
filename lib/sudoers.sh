# adds the user to sudoers if they are not already
function dotfiles_sudoers {
  # run as sudo if not root
  function _sudo {
    [[ $EUID -ne 0 ]] && sudo "$@" || "$@"
  }

  local user="${1:-$USER}"

  if [[ ! -f "/etc/sudoers.d/$user" ]] ; then
    _sudo mkdir -p /etc/sudoers.d
    echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" | _sudo tee "/etc/sudoers.d/$user" >/dev/null
    echo "dotfiles_sudoers: Log out and back in for passwordless sudo to take effect."
  fi
}
