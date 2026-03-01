#!/usr/bin/env bash
set -euo pipefail

for func in 'apt' 'bin' 'deb' 'homebrew' 'link' ; do
  source "$(dirname "${BASH_SOURCE[0]}")/lib/${func}.sh"
done

declare -a linux_apt=( 'aria2' 'build-essential' 'curl' 'file' 'git' 'git-lfs' 'gnupg' 'jq' 'libfuse2' 'sqlite3' 'wget' 'xsel' )
declare -a linux_apt_python=( 'libbz2-dev' 'libffi-dev' 'liblzma-dev' 'libncurses-dev' 'libreadline-dev' 'libsqlite3-dev' 'libssl-dev' 'zlib1g-dev' )

declare -a linux_deb=( 'burntsushi/ripgrep' 'lsd-rs/lsd' 'sharkdp/fd' 'ajeetdsouza/zoxide' )
declare -a linux_bin=( 'fzf' 'gh' 'lf' 'micro' )

echo 'Symlinking dotfiles...'
dotfiles_link

function _sudo {
  [[ $EUID -ne 0 ]] && sudo "$@" || "$@"
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
  dotfiles_apt "${linux_apt[@]}" "${linux_apt_python[@]}"

  echo 'Installing deb packages...'
  dotfiles_deb "${linux_deb[@]}"

  echo 'Installing binaries...'
  dotfiles_bin "${linux_bin[@]}"

  unset DEBIAN_FRONTEND
fi

# Run `xcode-select --install` to install developer tools.
if [[ $(uname -s) == 'Darwin' ]] ; then
  echo 'Installing Homebrew...'
  dotfiles_homebrew

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
