# installs fish (linux only)
function dotfiles_fish {
  source "$(dirname "${BASH_SOURCE[0]}")/sudo.sh"

  # use homebrew on mac
  if [[ -z $(command -v apt 2>/dev/null) || $(uname -s) != 'Linux' ]] ; then
    echo 'dotfiles_fish: Unsupported OS'
    return 1
  fi

  # if fish is already in PATH exit
  if [[ -n $(command -v fish 2>/dev/null) ]] ; then
    echo 'dotfiles_fish: fish is already installed!'
    return 0
  fi

  # install `apt-add-repository`
  if [[ -z $(command -v apt-add-repository 2>/dev/null) ]] ; then
    dotfiles_sudo apt-get update
    dotfiles_sudo apt-get install -y software-properties-common
  fi

  # install fish
  dotfiles_sudo apt-add-repository -y ppa:fish-shell/release-3
  dotfiles_sudo apt-get update
  dotfiles_sudo apt-get install -y fish | grep -v 'warning: ' # ignore update-alternatives warnings

  # install fisher if ~/.config/fish/fish_plugins exists
  local url='https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish'
  if [[ -f ~/.config/fish/fish_plugins || -L ~/.config/fish/fish_plugins ]] ; then
    fish -c "curl -fsSL $url | source && fisher update"
  else
    fish -c "curl -fsSL $url | source && fisher install jorgebucaran/fisher@main"
  fi
}
