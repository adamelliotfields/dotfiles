# configures ssh server
function dotfiles_ssh {
  # run as sudo if not root
  function _sudo {
    [[ $EUID -ne 0 ]] && sudo "$@" || "$@"
  }

  # NOTE: make sure sshd_config includes sshd_config.d/*.conf files
  _sudo mkdir -p /etc/ssh/sshd_config.d
  _sudo rm -f /etc/ssh/sshd_config.d/*.conf

  # disable ipv6
  if [[ ! -f '/etc/ssh/sshd_config.d/99-no-ipv6.conf' ]] ; then
    echo 'AddressFamily inet' \
      | _sudo tee /etc/ssh/sshd_config.d/99-no-ipv6.conf >/dev/null
  fi

  # disable last login message
  if [[ ! -f '/etc/ssh/sshd_config.d/99-no-lastlog.conf' ]] ; then
    echo 'PrintLastLog no' \
      | _sudo tee /etc/ssh/sshd_config.d/99-no-lastlog.conf >/dev/null
  fi

  # disable password authentication
  if [[ ! -f '/etc/ssh/sshd_config.d/99-no-password.conf' ]] ; then
    printf '%s\n' \
      'PermitRootLogin no' \
      'PubkeyAuthentication yes' \
      'PasswordAuthentication no' \
      'AuthorizedKeysFile .ssh/authorized_keys' \
      'KbdInteractiveAuthentication no' \
      'UsePAM yes' \
      | _sudo tee /etc/ssh/sshd_config.d/99-no-password.conf >/dev/null
  fi
}
