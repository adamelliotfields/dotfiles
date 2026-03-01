# installs btop (linux only)
dotfiles_btop() {
  # run as sudo if not root
  function _sudo {
    [[ $EUID -ne 0 ]] && sudo "$@" || "$@"
  }

  # use homebrew on mac
  if [[ "$(uname -s)" != 'Linux' ]] ; then
    echo 'dotfiles_deb: Unsupported OS'
    return 1
  fi

  # exit if installed
  if command -v btop >/dev/null ; then
    return 0
  fi

  # install
  # run `make uninstall` to remove
  git clone https://github.com/aristocratos/btop.git /tmp/btop

  # on amd64, gpu support is handled automatically
  make -C /tmp/btop
  _sudo make -C /tmp/btop install
  rm -rf /tmp/btop
}
