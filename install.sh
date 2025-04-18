#!/usr/bin/env bash
set -euo pipefail

for func in 'apt' 'deb' 'homebrew' 'link' ; do
  source "$(dirname "${BASH_SOURCE[0]}")/lib/${func}.sh"
done

declare -a linux_apt=( 'aria2' 'build-essential' 'curl' 'fzf' 'git' 'git-lfs' 'gnupg' 'jq' 'libfuse2' 'nano' 'ripgrep' 'unzip' 'wget' )
declare -a linux_apt_python=( 'libbz2-dev' 'libffi-dev' 'liblzma-dev' 'libncurses-dev' 'libreadline-dev' 'libsqlite3-dev' 'libssl-dev' 'zlib1g-dev' )
declare -a linux_deb=( 'cli/cli' 'lsd-rs/lsd' 'sharkdp/bat' 'sharkdp/diskus' 'sharkdp/fd' 'ajeetdsouza/zoxide' )

echo 'Symlinking dotfiles...'
dotfiles_link

# For Linux, omit Python, Node, and Fish.
# This is mostly run in dev containers which already have runtimes installed.
# Installing Fish requires a lot of dependencies which slows down container creation.
if [[ $(uname -s) == 'Linux' ]] ; then
  export DEBIAN_FRONTEND=noninteractive

  echo 'Installing apt packages...'
  dotfiles_apt "${linux_apt[@]}" "${linux_apt_python[@]}"

  echo 'Installing deb packages...'
  dotfiles_deb "${linux_deb[@]}"

  echo 'Installing liquidprompt...'
  rm -rf "${HOME:?}/.liquidprompt"
  git clone --depth=1 --branch=stable https://github.com/nojhan/liquidprompt.git "${HOME:?}/.liquidprompt"

  unset DEBIAN_FRONTEND
fi

# For Mac, run `xcode-select --install` to install developer tools.
# Then, run `dotfiles_sudoers` and logout to grant passwordless sudo to the current user.
if [[ $(uname -s) == 'Darwin' ]] ; then
  echo 'Installing Homebrew...'
  dotfiles_homebrew

  echo 'Installing Homebrew packages...'
  eval "$(brew shellenv)"
  brew bundle --global --no-lock

  # requires fnm (installed by brew)
  echo 'Installing Node.js LTS...'
  fnm install 'lts/*'

  # requires fish and fisher (installed by brew)
  echo 'Installing Fish plugins...'
  fish -c 'fisher update'

  # command + shift + .
  echo 'Showing hidden files in Finder...'
  defaults write com.apple.finder AppleShowAllFiles true
  killall Finder
fi

echo 'Done!'
