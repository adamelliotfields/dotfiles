#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

declare -a linux_apt=( 'aria2' 'build-essential' 'curl' 'file' 'git' 'git-lfs' 'gnupg' 'jq' 'sqlite3' 'wget' 'xsel' )
declare -a linux_apt_lib=( 'libbz2-dev' 'libffi-dev' 'libfuse2' 'liblzma-dev' 'libncurses-dev' 'libnss3' 'libreadline-dev' 'libsqlite3-dev' 'libssl-dev' 'zlib1g-dev' )

declare -a linux_deb=( 'burntsushi/ripgrep' 'lsd-rs/lsd' 'sharkdp/fd' 'ajeetdsouza/zoxide' )
declare -a linux_bin=( 'fzf' 'gh' 'lf' 'micro' )

echo 'Symlinking dotfiles...'
"$script_dir/bin/install_symlinks.sh"

function _sudo {
  if [[ $EUID -ne 0 ]] ; then
    sudo "$@"
  else
    "$@"
  fi
}

# Omit Python, Node, and Fish.
# This is mostly run in dev containers which already have runtimes installed.
# Installing Fish requires a lot of dependencies which slows down container creation.
if [[ $(uname -s) == 'Linux' ]] ; then
  export DEBIAN_FRONTEND=noninteractive

  # remove yarn if present
  if command -v yarn >/dev/null 2>&1 ; then
    echo 'Removing yarn...'
    _sudo apt remove -y --purge yarn
    _sudo rm -f /etc/apt/sources.list.d/yarn.list
  fi

  echo 'Installing apt packages...'
  "$script_dir/bin/setup_apt.sh"
  _sudo apt-get install -y --no-install-recommends "${linux_apt[@]}" "${linux_apt_lib[@]}" | sed '/warning: /d'

  echo 'Installing deb packages...'
  "$script_dir/bin/install_deb.sh" "${linux_deb[@]}"

  echo 'Installing binaries...'
  "$script_dir/bin/install_bin.sh" "${linux_bin[@]}"

  unset DEBIAN_FRONTEND
fi

# Run `xcode-select --install` to install developer tools.
if [[ $(uname -s) == 'Darwin' ]] ; then
  echo 'Installing Homebrew...'
  "$script_dir/bin/install_brew.sh"

  echo 'Installing Homebrew packages...'
  eval "$(brew shellenv)"
  brew install fish fisher node python

  # requires fish and fisher (installed above)
  echo 'Installing Fish plugins...'
  fish -c 'fisher update'

  # command + shift + .
  echo 'Showing hidden files in Finder...'
  defaults write com.apple.finder AppleShowAllFiles true
  killall Finder
fi

echo 'Done!'
