#!/usr/bin/env bash
# installs btop
dotfiles_btop() {
  source "$(dirname "${BASH_SOURCE[0]}")/sudo.sh"

  # use homebrew on Mac
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

# if not sourced
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
  dotfiles_btop "$@"
fi
