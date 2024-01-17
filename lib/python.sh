#!/usr/bin/env bash
# installs pyenv, python and pipx
dotfiles_python() {
  local version="$1"
  local pyenv_root="${HOME:?}/.pyenv"

  rm -rf "$pyenv_root"
  git clone --depth=1 https://github.com/pyenv/pyenv.git "$pyenv_root"
  git clone --depth=1 https://github.com/pyenv/pyenv-update.git "$pyenv_root/plugins/pyenv-update"

  PYENV_ROOT="${pyenv_root}"
  PATH="${PYENV_ROOT}/bin:${HOME}/.local/bin:${PATH}"

  # don't use bare "3" because that can install a new minor version not supported by anything
  [[ -z "$version" ]] && version=3.11.7

  # requires libbz2-dev libffi-dev liblzma-dev libncurses-dev libreadline-dev libsqlite3-dev libssl-dev zlib1g-dev
  pyenv install "$version"
  pyenv global "$version" # creates ~/.pyenv/version
  pyenv exec pip install --user pipx
}

# if not sourced
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
  dotfiles_python "$@"
fi
