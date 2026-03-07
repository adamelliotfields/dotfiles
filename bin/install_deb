#!/usr/bin/env bash
set -euo pipefail

# Downloads supported .deb packages from GitHub releases and installs with dpkg.
main() {
  local force=0
  local -a repos=()
  for arg in "$@" ; do
    case "$arg" in
      -f|--force) force=1 ;;
      *)          repos+=("$arg") ;;
    esac
  done

  local DELAY=1

  local token="${GITHUB_TOKEN:-}"
  token="${GH_TOKEN:-$token}"

  local os arch
  os=$(uname -s)
  arch=$(uname -m)

  if [[ "$os" != 'Linux' ]] || ! command -v dpkg >/dev/null 2>&1 ; then
    echo 'install_deb: Unsupported OS'
    return 1
  fi

  if ! command -v jq >/dev/null 2>&1 ; then
    echo 'install_deb: install jq'
    return 1
  fi

  local arch_deb=''
  case "$arch" in
    aarch64|arm64) arch_deb='arm64' ;;
    x86_64|amd64)  arch_deb='amd64' ;;
    *)
      echo 'install_deb: Unsupported architecture'
      return 1
      ;;
  esac

  local opts=(-fsSL)
  if [[ -n "$token" ]] ; then
    echo 'install_deb: Using GitHub API token...'
    opts+=(-H "Authorization: token $token")
    DELAY=0
  fi

  for repo in "${repos[@]}" ; do
    local package="${repo##*/}"
    local cmd_name="$package"
    case "$package" in
      ripgrep) cmd_name='rg' ;;
    esac

    if [[ "$force" -eq 0 ]] && command -v "$cmd_name" >/dev/null 2>&1 ; then
      continue
    fi

    local pattern="^${package}_.+_${arch_deb}\\.deb$"
    local assets
    assets=$(curl "${opts[@]}" "https://api.github.com/repos/$repo/releases/latest" | jq -r '.assets')

    local asset
    asset=$(echo "$assets" | jq -c -r --arg p "$pattern" '.[] | select(.name | test($p))' | head -n1)

    if [[ -z "$asset" ]] ; then
      echo "install_deb: $repo deb not found"
      return 1
    fi

    local browser_download_url filename
    browser_download_url=$(echo "$asset" | jq -r '.browser_download_url')
    filename=$(basename "$browser_download_url")

    sleep "$DELAY" && curl -fsSL -o "/tmp/$filename" "$browser_download_url"

    _sudo dpkg -i "/tmp/$filename"
    rm -f "/tmp/$filename"
  done
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
