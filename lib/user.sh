#!/usr/bin/env bash
# create a passwordless sudoers user
function dotfiles_user {
  source "$(dirname "${BASH_SOURCE[0]}")/sudo.sh"
  source "$(dirname "${BASH_SOURCE[0]}")/sudoers.sh"

  if [[ $# -ne 1 ]] ; then
    echo 'dotfiles_user: Requires exactly 1 argument'
    return 1
  fi

  local user=$1

  # check if user already exists
  if id "$user" &>/dev/null ; then
    echo "dotfiles_user: User ${user} already exists"
    return 1
  fi

  dotfiles_sudo adduser --disabled-password --gecos "" $user
  dotfiles_sudoers $user
}

# if not sourced
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
  dotfiles_user "$@"
fi
