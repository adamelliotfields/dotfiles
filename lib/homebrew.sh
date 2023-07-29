# shellcheck shell=bash
# installs homebrew
function dotfiles_homebrew {
  # already installed
  if command -v brew >/dev/null ; then
    return 0
  fi

  # to be truly non-interactive you must already have passwordless sudo enabled (see sudoers.sh)
  local url='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
  NONINTERACTIVE=1 /usr/bin/env bash -c "$(curl -fsSL $url)"
}
