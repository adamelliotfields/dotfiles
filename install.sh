#!/usr/bin/env bash
set -euo pipefail

for func in 'apt' 'clone' 'deb' 'homebrew' 'link' 'nvm' 'python' ; do
  source "$(dirname "$0")/lib/${func}.sh"
done

# linux config
declare -a linux_prompts=( 'nojhan/liquidprompt' )
declare -a linux_apt=( 'build-essential' 'curl' 'fzf' 'git' 'gnupg' 'jq' 'ripgrep' 'unzip' 'wget' )
declare -a linux_apt_python=( 'libbz2-dev' 'libffi-dev' 'liblzma-dev' 'libncurses-dev' 'libreadline-dev' 'libsqlite3-dev' )
declare -a linux_deb=( 'cli/cli' 'lsd-rs/lsd' 'sharkdp/bat' 'sharkdp/fd' 'ajeetdsouza/zoxide' )

echo 'Symlinking dotfiles...'
dotfiles_link

# linux
if [[ $(uname -s) == 'Linux' ]] ; then
  export DEBIAN_FRONTEND=noninteractive

  echo 'Installing apt packages...'
  dotfiles_apt "${linux_apt[@]}" "${linux_apt_python[@]}"

  echo 'Installing deb packages...'
  dotfiles_deb "${linux_deb[@]}"

  # install prompts with homebrew on mac
  echo 'Installing prompts...'
  dotfiles_clone "${linux_prompts[@]}"
  unset DEBIAN_FRONTEND
fi

# mac
# run these commands manually and log out after each before proceding:
#   $ source lib/sudoers.sh ; dotfiles_sudoers
#   $ source lib/chsh.sh ; dotfiles_chsh /bin/bash
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

  # requires some homebrew packages (installed above)
  echo 'Installing Python...'
  dotfiles_python

  echo 'Installing nvm and Node LTS...'
  dotfiles_nvm 'lts/*'

  # command + shift + .
  echo 'Showing hidden files in Finder...'
  defaults write com.apple.finder AppleShowAllFiles true
  killall Finder
fi

echo 'Done! 🎉'
