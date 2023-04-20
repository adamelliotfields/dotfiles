# shellcheck shell=bash
with_sudo() {
  if [ $EUID -ne 0 ] ; then
    sudo "$@"
  else
    "$@"
  fi
}
