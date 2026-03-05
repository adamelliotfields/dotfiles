#!/usr/bin/env bash
set -euo pipefail

# Configures apt on a fresh Linux installation.
main() {
  if [[ "$(uname -s)" != 'Linux' ]] || ! command -v apt-get >/dev/null 2>&1 ; then
    echo 'setup_apt: Unsupported OS'
    return 1
  fi

  # Ubuntu images can be "minimized" so they don't download man pages.
  [[ -f /etc/dpkg/dpkg.cfg.d/excludes ]] && _sudo rm -f /etc/dpkg/dpkg.cfg.d/excludes
  [[ -f /etc/update-motd.d/60-unminimize ]] && _sudo rm -f /etc/update-motd.d/60-unminimize

  # Remove diverted man binary if it exists.
  if command -v dpkg-divert >/dev/null 2>&1 && [[ "$(dpkg-divert --truename /usr/bin/man)" == '/usr/bin/man.REAL' ]] ; then
    _sudo rm -f /usr/bin/man
    _sudo dpkg-divert --quiet --remove --rename /usr/bin/man
  fi

  # Don't download man page translations when installing packages.
  if [[ ! -f /etc/apt/apt.conf.d/99translations ]] ; then
    _sudo mkdir -p /etc/apt/apt.conf.d
    echo 'Acquire::Languages "none";' | _sudo tee /etc/apt/apt.conf.d/99translations >/dev/null
  fi

  _sudo apt-get update
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
