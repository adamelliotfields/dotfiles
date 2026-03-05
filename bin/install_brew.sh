#!/usr/bin/env bash
set -euo pipefail

# Installs Homebrew on macOS and Linux.
main() {
  local os
  os="$(uname -s)"
  if [[ "$os" != 'Darwin' && "$os" != 'Linux' ]] ; then
    echo 'install_brew: Unsupported OS'
    return 1
  fi

  if command -v brew >/dev/null 2>&1 ; then
    return 0
  fi

  # For full non-interactive behavior, sudo must already be passwordless.
  local url='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
  NONINTERACTIVE=1 /usr/bin/env bash -c "$(curl -fsSL "$url")"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]] ; then
  main "$@"
fi
