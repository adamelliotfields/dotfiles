#!/usr/bin/env bash
set -euo pipefail

# Installs btop from source (Linux only).
main() {
  local force=0
  for arg in "$@" ; do
    case "$arg" in
      -f|--force) force=1 ;;
      *)
        echo "install_btop: Unsupported argument '$arg'"
        return 1
        ;;
    esac
  done

  if [[ "$(uname -s)" != 'Linux' ]] ; then
    echo 'install_btop: Unsupported OS'
    return 1
  fi

  if ! command -v jq >/dev/null 2>&1 ; then
    echo 'install_btop: install jq'
    return 1
  fi

  if ! command -v g++-14 >/dev/null 2>&1 ; then
    echo 'install_btop: install g++-14'
    return 1
  fi

  local cxx='g++-14'

  if [[ "$force" -eq 0 ]] && command -v btop >/dev/null 2>&1 ; then
    return 0
  fi

  local workdir
  workdir=$(mktemp -d /tmp/btop_XXXXXX)
  local cleanup_cmd
  printf -v cleanup_cmd 'rm -rf -- %q' "$workdir"
  trap "$cleanup_cmd" EXIT

  local token="${GITHUB_TOKEN:-}"
  token="${GH_TOKEN:-$token}"

  local opts=(-fsSL)
  if [[ -n "$token" ]] ; then
    echo 'install_btop: Using GitHub API token...'
    opts+=(-H "Authorization: token $token")
  fi

  local tag_name
  tag_name=$(curl "${opts[@]}" 'https://api.github.com/repos/aristocratos/btop/releases/latest' | jq -r '.tag_name')
  if [[ -z "$tag_name" ]] || [[ "$tag_name" == 'null' ]] || [[ ! "$tag_name" =~ ^v[0-9]+(\.[0-9]+)*$ ]] ; then
    echo 'install_btop: failed to resolve latest tag'
    return 1
  fi

  git clone --depth 1 --branch "$tag_name" --no-checkout https://github.com/aristocratos/btop.git "$workdir/btop"
  git -C "$workdir/btop" switch --no-track -c "$tag_name" "$tag_name"

  make -C "$workdir/btop" CXX="$cxx"
  _sudo make -C "$workdir/btop" install
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
