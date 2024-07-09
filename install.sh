#!/usr/bin/env bash
set -euo pipefail

for func in 'apt' 'clone' 'deb' 'homebrew' 'link' 'node' 'python' ; do
  source "$(dirname "${BASH_SOURCE[0]}")/lib/${func}.sh"
done

# linux config
declare -a linux_prompts=( 'nojhan/liquidprompt' )
declare -a linux_apt=( 'build-essential' 'curl' 'fzf' 'git' 'gnupg' 'jq' 'ripgrep' 'unzip' 'wget' )
declare -a linux_apt_python=( 'libbz2-dev' 'libffi-dev' 'liblzma-dev' 'libncurses-dev' 'libreadline-dev' 'libsqlite3-dev' 'libssl-dev' 'zlib1g-dev' )
declare -a linux_deb=( 'cli/cli' 'lsd-rs/lsd' 'sharkdp/bat' 'sharkdp/diskus' 'sharkdp/fd' 'ajeetdsouza/zoxide' )

echo 'Symlinking dotfiles...'
dotfiles_link

# linux
if [[ $(uname -s) == 'Linux' ]] ; then
  export DEBIAN_FRONTEND=noninteractive

  echo 'Installing apt packages...'
  dotfiles_apt "${linux_apt[@]}" "${linux_apt_python[@]}"

  echo 'Installing deb packages...'
  dotfiles_deb "${linux_deb[@]}"

  # note: you install prompts with homebrew on mac
  echo 'Installing prompts...'
  dotfiles_clone "${linux_prompts[@]}"
  unset DEBIAN_FRONTEND
fi

# mac
# note: run lib/sudoers.sh and relog to enable passwordless sudo
if [[ $(uname -s) == 'Darwin' ]] ; then
  echo 'Installing Homebrew...'
  dotfiles_homebrew

  # comment out if you're in a hurry
  echo 'Installing Homebrew packages...'
  eval "$(brew shellenv)"
  brew bundle --global --no-lock

  # requires fish (installed above)
  echo 'Installing Fish plugins...'
  fish -c 'fisher update'

  # command + shift + .
  echo 'Showing hidden files in Finder...'
  defaults write com.apple.finder AppleShowAllFiles true
  killall Finder
fi

echo 'Done!'
