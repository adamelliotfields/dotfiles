# installs btop (linux only)
dotfiles_btop() {
  source "$(dirname "${BASH_SOURCE[0]}")/sudo.sh"

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
  dotfiles_sudo make -C /tmp/btop install
  rm -rf /tmp/btop
}
