#!/usr/bin/env bash
set -euo pipefail

# Installs the latest Go release from go.dev.
main() {
  local version
  version=$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -n1)
  if [[ -z "$version" ]] ; then
    echo 'install_go: failed to resolve latest version'
    return 1
  fi

  local arch='' os=''
  case "$(uname -m)" in
    aarch64|arm64) arch='arm64' ;;
    x86_64|amd64)  arch='amd64' ;;
    *)
      echo 'install_go: Unsupported architecture'
      return 1
      ;;
  esac

  case "$(uname -s)" in
    Darwin) os='darwin' ;;
    Linux)  os='linux' ;;
    *)
      echo 'install_go: Unsupported OS'
      return 1
      ;;
  esac

  if [[ "$os" == 'darwin' ]] && [[ "$arch" == 'amd64' ]] ; then
    if [[ "$(sysctl -n sysctl.proc_translated 2>/dev/null || echo 0)" -eq 1 ]] ; then
      echo 'install_go: Rosetta detected; installing arm64'
      arch='arm64'
    fi
  fi

  local filename="${version}.${os}-${arch}.tar.gz"
  local url="https://go.dev/dl/${filename}"
  local tmpfile="/tmp/${filename}"

  # Make sure /usr/local/go/bin is in your PATH.
  curl -fsSL -o "$tmpfile" "$url"
  _sudo tar -C /usr/local -xzf "$tmpfile"
  rm -f "$tmpfile"
}

_sudo() {
  if [[ $EUID -ne 0 ]] ; then
    sudo "$@"
  else
    "$@"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]] ; then
  main "$@"
fi
