#!/usr/bin/env bash
# installs miniforge (conda/mamba)
dotfiles_miniforge() {
  local os=''
  local arch=''

  # set os
  case "$(uname -s)" in
    Darwin) os='Darwin' ;;
    Linux)  os='Linux' ;;
    *)      echo "dotfiles_miniforge: Unsupported OS" ; return 1 ;;
  esac

  # set arch
  case "$(uname -m)" in
    arm64|aarch64) arch='aarch64' ;;
    amd64|x86_64)  arch='x86_64' ;;
    *)             echo "dotfiles_miniforge: Unsupported architecture" ; return 1 ;;
  esac

  # correct arch for darwin
  if [[ $os == 'Darwin' && $arch == 'aarch64' ]] ; then
    arch='arm64'
  fi

  local platform="${os}-${arch}"
  local url="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-${platform}.sh"

  # download to tmp
  curl -fsSL -o /tmp/miniforge.sh "$url"
  chmod +x /tmp/miniforge.sh

  # install
  # note: add .miniforge3/bin to $PATH
  /tmp/miniforge.sh -b -p "$HOME/.miniforge3"

  # cleanup
  rm -f /tmp/miniforge.sh
}

# if not sourced
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
  dotfiles_miniforge "$@"
fi
