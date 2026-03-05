#!/usr/bin/env bash
set -euo pipefail

# Installs a Nerd Font into the current user's font directory on Linux.
main() {
  if [[ "$(uname -s)" != 'Linux' ]] ; then
    echo 'install_nerdfont: Unsupported OS'
    return 1
  fi

  if ! command -v unzip >/dev/null 2>&1 ; then
    echo 'install_nerdfont: install unzip'
    return 1
  fi

  if ! command -v fc-cache >/dev/null 2>&1 ; then
    echo 'install_nerdfont: install fontconfig'
    return 1
  fi

  local name="$1"
  local url='https://github.com/ryanoasis/nerd-fonts/releases/latest'
  local tmpfile="/tmp/${name}.zip"
  local font_dir="${HOME}/.fonts/${name}"

  if ! curl -fsSL "${url}/download/${name}.zip" -o "$tmpfile" ; then
    echo "install_nerdfont: failed to download ${name}.zip"
    return 1
  fi

  # to uninstall run `rm -rf ~/.fonts/$name && fc-cache -f`
  mkdir -p "$font_dir"
  unzip -qod "$font_dir" "$tmpfile"
  rm -f "$tmpfile"
  fc-cache -f
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]] ; then
  main "$@"
fi
