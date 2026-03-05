#!/usr/bin/env bash
set -euo pipefail

# Installs Rust via rustup for the current platform.
main() {
  local default_toolchain='stable'
  local profile='default'
  local arch='' os=''

  case "$(uname -m)" in
    aarch64|arm64) arch='aarch64' ;;
    x86_64|amd64)  arch='x86_64' ;;
    *)
      echo 'install_rust: Unsupported architecture'
      return 1
      ;;
  esac

  case "$(uname -s)" in
    Darwin) os='apple-darwin' ;;
    Linux)  os='unknown-linux-gnu' ;;
    *)
      echo 'install_rust: Unsupported OS'
      return 1
      ;;
  esac

  # if x86_64-apple-darwin check if we're in Rosetta
  if [[ "$os" == 'apple-darwin' ]] && [[ "$arch" == 'x86_64' ]] ; then
    if [[ "$(sysctl -n sysctl.proc_translated 2>/dev/null || echo 0)" -eq 1 ]] ; then
      echo 'install_rust: Rosetta detected; installing aarch64'
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

if [[ "${BASH_SOURCE[0]}" == "$0" ]] ; then
  main "$@"
fi
