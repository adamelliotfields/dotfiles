# escalates privileges if necessary
function dotfiles_sudo {
  if [[ $EUID -ne 0 ]] ; then
    sudo "$@"
  else
    "$@"
  fi
}
