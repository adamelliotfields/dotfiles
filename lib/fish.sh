#!/usr/bin/env bash
# installs fish
function dotfiles_fish {
  # if fish is already in PATH exit
  if [[ -n $(command -v fish 2>/dev/null) ]] ; then
    echo 'dotfiles_fish: fish is already installed!'
    return 0
  fi

  if [[ -z $(command -v apt 2>/dev/null) || $(uname -s) != 'Linux' ]] ; then
    echo 'dotfiles_fish: Unsupported OS'
    return 1
  fi

  # install `apt-add-repository`
  sudo apt-get update
  sudo apt-get install -y software-properties-common

  # install fish
  sudo apt-add-repository -y ppa:fish-shell/release-3
  sudo apt-get update
  sudo apt-get install -y fish | grep -v 'warning: ' # ignore update-alternatives warnings

  # install fisher if ~/.config/fish/fish_plugins exists
  local url='https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish'
  if [[ -f ~/.config/fish/fish_plugins || -L ~/.config/fish/fish_plugins ]] ; then
    fish -c "curl -fsSL $url | source && fisher update"
  else
    fish -c "curl -fsSL $url | source && fisher install jorgebucaran/fisher@main"
  fi
}

# if not sourced
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
  dotfiles_fish "$@"
fi
