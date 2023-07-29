# shellcheck shell=bash
# installs rust via rustup
function dotfiles_rustup {
  local default_toolchain='stable'
  local profile='minimal'
  local arch=''
  local os=''

  # set arch
  case "$(uname -m)" in
    arm64|aarch64) arch='aarch64' ;;
    amd64|x86_64)  arch='x86_64' ;;
    *)             echo "dotfiles_rustup: Unsupported architecture" ; return 1 ;;
  esac

  # set os
  case "$(uname -s)" in
    Darwin) os='apple-darwin' ;;
    Linux)  os='unknown-linux-gnu' ;;
    *)      echo "dotfiles_rustup: Unsupported OS" ; return 1 ;;
  esac

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
