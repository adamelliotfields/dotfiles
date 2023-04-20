# shellcheck shell=bash
df_brew() {
  # not mac
  if [ "$(uname -s)" != 'Darwin' ] ; then
    echo "df_brew: Unsupported OS $(uname -s)"
    return 1
  fi

  # already installed
  if command -v brew >/dev/null ; then
    return 0
  fi

  local url='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
  NONINTERACTIVE=1 /usr/bin/env bash -c "$(curl -fsSL $url)"
}
