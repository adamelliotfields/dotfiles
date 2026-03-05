#!/usr/bin/env bash
set -euo pipefail

# Installs fish on Linux and updates fisher when fish plugins are present.
main() {
  if [[ "$(uname -s)" != 'Linux' ]] || ! command -v apt-get >/dev/null 2>&1 ; then
    echo 'install_fish: Unsupported OS'
    return 1
  fi

  if command -v fish >/dev/null 2>&1 ; then
    echo 'install_fish: fish is already installed!'
    return 0
  fi

  if ! command -v apt-add-repository >/dev/null 2>&1 ; then
    _sudo apt-get update
    _sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
  fi

  _sudo apt-add-repository -y ppa:fish-shell/release-3
  _sudo apt-get update
  _sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y fish | sed '/warning: /d'

  local url='https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish'
  if [[ -f ~/.config/fish/fish_plugins ]] || [[ -L ~/.config/fish/fish_plugins ]] ; then
    fish -c "curl -fsSL $url | source && fisher update"
  fi
}

_sudo() {
  if [[ $EUID -ne 0 ]] ; then
    sudo "$@"
  else
    "$@"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]] ; then
  main "$@"
fi
