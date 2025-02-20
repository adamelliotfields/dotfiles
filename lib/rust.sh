#!/usr/bin/env bash
# installs rust via rustup
function dotfiles_rust {
  local default_toolchain='stable'
  local profile='default'
  local arch=''
  local os=''

  # set arch
  case "$(uname -m)" in
    arm64|aarch64) arch='aarch64' ;;
    amd64|x86_64)  arch='x86_64' ;;
    *)             echo "dotfiles_rust: Unsupported architecture" ; return 1 ;;
  esac

  # set os
  case "$(uname -s)" in
    Darwin) os='apple-darwin' ;;
    Linux)  os='unknown-linux-gnu' ;;
    *)      echo "dotfiles_rust: Unsupported OS" ; return 1 ;;
  esac

  # if x86_64-apple-darwin check if we're in Rosetta
  if [[ $os == 'apple-darwin' && $arch == 'x86_64' ]] ; then
    if [[ $(sysctl -n sysctl.proc_translated 2>/dev/null) -eq 1 ]] ; then
      echo 'dotfiles_rust: Rosetta detected; installing aarch64'
      arch='aarch64'
    fi
  fi

  local default_host="${arch}-${os}"
  local -a opts=(
    '-y'
    '-q'
    '--no-modify-path'
    "--default-host=${default_host}"
    "--default-toolchain=${default_toolchain}"
    "--profile=${profile}"
  )

  curl -fsSL --proto '=https' --tlsv1.2 https://sh.rustup.rs | sh -s -- "${opts[@]}"
}

# if not sourced
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
  dotfiles_rust "$@"
fi
