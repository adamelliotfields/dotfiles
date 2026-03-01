# TODO: should take a password argument, otherwise use --disabled-password
# create a passwordless user
function dotfiles_user {
  # run as sudo if not root
  function _sudo {
    [[ $EUID -ne 0 ]] && sudo "$@" || "$@"
  }

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
  _sudo adduser --disabled-password --gecos "" "$user"
}
