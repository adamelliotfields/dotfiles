# installs homebrew (mac and linux)
function dotfiles_homebrew {
  local os
  os="$(uname -s)"
  if [[ "$os" != 'Darwin' && "$os" != 'Linux' ]] ; then
    echo 'dotfiles_homebrew: Unsupported OS'
    return 1
  fi

  # already installed
  if command -v brew >/dev/null ; then
    return 0
  fi

  # to be truly non-interactive you must already have passwordless sudo enabled (see sudoers.sh)
  local url='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
  NONINTERACTIVE=1 /usr/bin/env bash -c "$(curl -fsSL $url)"
}
