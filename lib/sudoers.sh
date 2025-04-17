# adds the user to sudoers if they are not already (i.e., passwordless sudo) (requires a complete logout/login to take effect)
function dotfiles_sudoers {
  source "$(dirname "${BASH_SOURCE[0]}")/sudo.sh"

  local user="${1:-$USER}"

  if [[ ! -f "/etc/sudoers.d/$user" ]] ; then
    dotfiles_sudo mkdir -p /etc/sudoers.d
    echo "$user ALL=(ALL) NOPASSWD:ALL" | dotfiles_sudo tee "/etc/sudoers.d/$user" >/dev/null
  fi
}
