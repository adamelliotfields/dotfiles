#!/usr/bin/env bash
set -euo pipefail

# Installs a fastfetch-based message of the day on Linux systems.
main() {
  if [[ "$(uname -s)" != 'Linux' ]] ; then
    echo 'add_motd: Unsupported OS'
    return 1
  fi

  _sudo mkdir -p /etc/update-motd.d
  _sudo rm -f /etc/update-motd.d/*

  _sudo tee /etc/update-motd.d/99-fastfetch >/dev/null <<'EOF'
#!/bin/sh
fastfetch \
--pipe false \
--logo linux \
--structure Logo
printf '\n'
fastfetch \
--pipe false \
--logo none \
--color-keys yellow \
--structure-disabled Title:Separator:Host:Shell:Terminal:Display:Theme:Icons:Cursor:Swap:Locale:Break:Colors
EOF

  _sudo chmod +x /etc/update-motd.d/99-fastfetch
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
