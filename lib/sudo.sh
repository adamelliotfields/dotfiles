#!/usr/bin/env bash
# escalates privileges if necessary
function dotfiles_sudo {
  if [[ $EUID -ne 0 ]] ; then
    sudo "$@"
  else
    "$@"
  fi
}

# if not sourced
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
  dotfiles_sudo "$@"
fi
