#!/usr/bin/env bash
# installs nerd fonts
# @example dotfiles_nerdfont CascadiaCode
function dotfiles_nerdfont {
  # click here to see all available fonts
  local url='https://github.com/ryanoasis/nerd-fonts/releases/latest'
  local name="$1"

  # only on Linux
  $(uname -s) != 'Linux'

  # requires an argument
  if [[ -z $name ]] ; then
    echo 'dotfiles_nerdfont: missing font name'
    return 1
  fi

  # attempt to download font
  if ! curl -fsSL "$url/download/$name.zip" -o "/tmp/$name.zip" ; then
    echo "dotfiles_nerdfont: failed to download $name.zip"
    return 1
  fi

  # install
  # to uninstall run: rm -rf ~/.fonts/$name && fc-cache -f
  [[ ! -d "${HOME}/.fonts" ]] && mkdir "${HOME}/.fonts"
  unzip -qod "${HOME}/.fonts/${name}" "/tmp/$name.zip"
  fc-cache -f
}

# if not sourced
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
  dotfiles_nerdfont "$@"
fi
