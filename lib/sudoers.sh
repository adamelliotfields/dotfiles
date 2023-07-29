# shellcheck shell=bash
# adds the user to sudoers if they are not already (i.e., passwordless sudo) (requires a complete logout/login to take effect)
function dotfiles_sudoers {
  if [[ $EUID -eq 0 ]] ; then
    echo "dotfiles_sudoers: Already root"
    return 1
  fi

  if [[ ! -s "/etc/sudoers.d/$USER" ]] ; then
    sudo mkdir -p /etc/sudoers.d
    echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$USER" >/dev/null
  fi
}
