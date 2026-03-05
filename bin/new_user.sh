#!/usr/bin/env bash
set -euo pipefail

# Creates a passwordless sudo user and optionally sets their login shell.
main() {
  if [[ "$(uname -s)" != 'Linux' ]] ; then
    echo 'new_user: Unsupported OS'
    return 1
  fi

  local user="$1"
  local shell="${2:-}"

  if id "$user" >/dev/null 2>&1 ; then
    echo "new_user: user ${user} already exists"
    return 1
  fi

  if [[ -n "$shell" ]] ; then
    if [[ ! -x "$shell" ]] ; then
      echo "new_user: shell '$shell' not found"
      return 1
    fi
  fi

  _sudo adduser --disabled-password --gecos "" "$user"

  if [[ ! -f "/etc/sudoers.d/$user" ]] ; then
    _sudo mkdir -p /etc/sudoers.d
    echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" | _sudo tee "/etc/sudoers.d/$user" >/dev/null
    _sudo chmod 0440 "/etc/sudoers.d/$user"
  fi

  if [[ -n "$shell" ]] ; then
    if ! grep -qxF "$shell" /etc/shells ; then
      echo "$shell" | _sudo tee -a /etc/shells >/dev/null
    fi

    _sudo chsh -s "$shell" "$user"
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
