#!/usr/bin/env bash
set -euo pipefail

# Configures sshd drop-ins for key-only logins on Linux.
main() {
  if [[ "$(uname -s)" != 'Linux' ]] ; then
    echo 'setup_ssh: Unsupported OS'
    return 1
  fi

  # Make sure sshd_config includes sshd_config.d/*.conf files.
  _sudo mkdir -p /etc/ssh/sshd_config.d
  _sudo rm -f /etc/ssh/sshd_config.d/*.conf

  echo 'AddressFamily inet' | _sudo tee /etc/ssh/sshd_config.d/99-no-ipv6.conf >/dev/null
  echo 'PrintLastLog no' | _sudo tee /etc/ssh/sshd_config.d/99-no-lastlog.conf >/dev/null

  printf '%s\n' \
    'PermitRootLogin no' \
    'PubkeyAuthentication yes' \
    'PasswordAuthentication no' \
    'AuthorizedKeysFile .ssh/authorized_keys' \
    'KbdInteractiveAuthentication no' \
    'UsePAM yes' \
    | _sudo tee /etc/ssh/sshd_config.d/99-no-password.conf >/dev/null
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
