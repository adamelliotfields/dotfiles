# adds the user to sudoers if they are not already
function dotfiles_sudoers {
  source "$(dirname "${BASH_SOURCE[0]}")/sudo.sh"

  local user="${1:-$USER}"

  if [[ ! -f "/etc/sudoers.d/$user" ]] ; then
    dotfiles_sudo mkdir -p /etc/sudoers.d
    echo "$user ALL=(ALL) NOPASSWD:ALL" | dotfiles_sudo tee "/etc/sudoers.d/$user" >/dev/null
    echo "dotfiles_sudoers: Log out and back in for passwordless sudo to take effect."
  fi
}
