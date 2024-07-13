#!/usr/bin/env bash
# downloads a list of deb packages from GitHub releases and installs them with dpkg (linux only)
function dotfiles_deb {
  source "$(dirname "${BASH_SOURCE[0]}")/sudo.sh"
  local -a repos=("$@")

  # delay between requests when unauthenticated
  local DELAY=1

  # prefer GH_TOKEN
  local token="${GITHUB_TOKEN:-}"
  local token="${GH_TOKEN:-$token}"

  if [[ -z $(command -v dpkg 2>/dev/null) || "$(uname -s)" != 'Linux' ]] ; then
    echo 'dotfiles_deb: Unsupported OS'
    return 1
  fi

  for repo in "${repos[@]}" ; do
    local bin=$(echo "$repo" | awk -F '/' '{print $2}')
    local opts='-fsSL'
    local arch=''

    # if token is available use it
    if [[ -n "$token" ]] ; then
      echo 'dotfiles_deb: Using GitHub API token...'
      opts="$opts -H 'Authorization: token $token'"
      DELAY=0
    fi

    # set arch
    case "$(uname -m)" in
      aarch64|arm64) arch='arm64' ;;
      x86_64|amd64)  arch='amd64' ;;
      *)             echo 'dotfiles_deb: Unsupported architecture' ; return 1 ;;
    esac

    # GitHub CLI is installed as `gh`
    if [[ "$repo" = 'cli/cli' ]] ; then
      bin='gh'
      arch="linux_${arch}"
    fi

    # already installed
    if command -v "$bin" >/dev/null ; then
      continue
    fi

    # get the latest release
    local assets=$(eval "curl $opts https://api.github.com/repos/$repo/releases/latest" | jq -r '.assets')
    local asset="$(echo "$assets" | jq -r ".[] | select(.name | test(\"${bin}_(.+)_${arch}.deb\"))")"

    # no deb
    if [[ -z "$asset" ]] ; then
      echo "dotfiles_deb: $repo deb not found"
      return 1
    fi

    # download the deb
    local browser_download_url=$(echo "$asset" | jq -r '.browser_download_url')
    local filename=$(basename "$browser_download_url")
    sleep $DELAY && eval "curl -fsSL $browser_download_url -o /tmp/$filename"

    # install and cleanup
    dotfiles_sudo dpkg -i "/tmp/$filename"
    rm -f "/tmp/$filename"
  done
}

# if not sourced
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
  dotfiles_deb "$@"
fi
