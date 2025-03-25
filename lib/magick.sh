#!/usr/bin/env bash
# installs imagemagick from GitHub instead of imagemagick.org
dotfiles_magick() {
  # already installed
  if command -v magick >/dev/null ; then
    echo "dotfiles_magick: ImageMagick is already installed"
    return 0
  fi

  # prefer "clang" (llvm) over "gcc"
  local COMPILER='clang'

  # prefer GH_TOKEN
  local token="${GITHUB_TOKEN:-}"
  local token="${GH_TOKEN:-$token}"

  # use token if available
  local delay=1
  local opts=(-fsSL)
  if [[ -n "$token" ]] ; then
    delay=0
    opts+=(-H "Authorization: token $token")
  fi

  # get the download URL for the latest release
  local download_url=$(curl "${opts[@]}" 'https://api.github.com/repos/ImageMagick/ImageMagick/releases/latest' | jq -r ".assets[] | select(.name | contains(\"$COMPILER-x86_64.AppImage\")) | .browser_download_url")

  # invalid compiler or the file name changed
  if [[ -z "$download_url" ]] ; then
    echo "dotfiles_magick: No release for '$COMPILER' compiler"
    return 1
  fi

  # clean before downloading
  local dest_file='/tmp/magick'
  rm -f "$dest_file"

  # wait when unauthenticated to avoid rate limiting
  sleep $delay && wget -qO "$dest_file" "$download_url"

  # make executable
  chmod +x "$dest_file"

  # move to path
  sudo mv "$dest_file" /usr/local/bin/magick
}

# if not sourced
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
  dotfiles_magick "$@"
fi
