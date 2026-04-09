#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

declare -a linux_apt=( 'aria2' 'build-essential' 'cmake' 'curl' 'file' 'git' 'git-lfs' 'gnupg' 'jq' 'ninja-build' 'sqlite3' 'wget' 'xsel' )
declare -a linux_apt_lib=( 'libbz2-dev' 'libffi-dev' 'libfuse2' 'liblzma-dev' 'libncurses-dev' 'libnss3' 'libreadline-dev' 'libsqlite3-dev' 'libssl-dev' 'zlib1g-dev' )

declare -a linux_deb=( 'burntsushi/ripgrep' 'lsd-rs/lsd' 'sharkdp/fd' 'ajeetdsouza/zoxide' )
declare -a linux_bin=( 'fzf' 'gh' 'lf' 'micro' )

export DEBIAN_FRONTEND=noninteractive

function _sudo {
  if [[ $EUID -ne 0 ]] ; then
    sudo "$@"
  else
    "$@"
  fi
}

# Install Python if not present
if ! command -v python3 >/dev/null 2>&1 ; then
  _sudo apt-get update
  _sudo apt-get install -y python3
fi

# Remove yarn if present
if command -v yarn >/dev/null 2>&1 ; then
  _sudo apt remove -y --purge yarn
  _sudo rm -f /etc/apt/sources.list.d/yarn.list
fi

# Install apt packages
"$script_dir/bin/dotfiles" setup apt
_sudo apt-get install -y --no-install-recommends "${linux_apt[@]}" "${linux_apt_lib[@]}" | sed '/warning: /d'

# Install deb packages
for repo in "${linux_deb[@]}" ; do
  "$script_dir/bin/dotfiles" install deb "$repo"
done

# Install binaries
for name in "${linux_bin[@]}" ; do
  "$script_dir/bin/dotfiles" install bin "$name"
done

# Symlink dotfiles
"$script_dir/bin/dotfiles" install symlinks

unset DEBIAN_FRONTEND
