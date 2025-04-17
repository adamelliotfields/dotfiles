# create a passwordless user
function dotfiles_user {
  source "$(dirname "${BASH_SOURCE[0]}")/sudo.sh"

  # validate arguments
  if [[ $# -ne 1 ]] ; then
    echo 'dotfiles_user: Requires exactly 1 argument'
    return 1
  fi

  # check if user already exists
  local user=$1
  if id "$user" &>/dev/null ; then
    echo "dotfiles_user: User ${user} already exists"
    return 1
  fi

  # create the user
  dotfiles_sudo adduser --disabled-password --gecos "" "$user"
}
