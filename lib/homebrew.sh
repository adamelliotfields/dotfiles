# installs homebrew (mac only)
function dotfiles_homebrew {
  if [[ "$(uname -s)" != 'Darwin' ]] ; then
    echo 'dotfiles_deb: Unsupported OS'
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
