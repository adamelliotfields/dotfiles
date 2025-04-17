# installs pyenv, python and pipx
dotfiles_python() {
  PYENV_ROOT="${HOME:?}/.pyenv"
  PATH="${PYENV_ROOT}/bin:${HOME}/.local/bin:${PATH}"

  local version="$1"

  # run `pyenv update` to update (i.e., get new versions)
  rm -rf "$PYENV_ROOT"
  git clone --depth=1 https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
  git clone --depth=1 https://github.com/pyenv/pyenv-update.git "$PYENV_ROOT/plugins/pyenv-update"

  # don't use bare "3" because that can install a new minor version not supported by anything
  [[ -z "$version" ]] && version=3.11.9

  # requires libbz2-dev libffi-dev liblzma-dev libncurses-dev libreadline-dev libsqlite3-dev libssl-dev zlib1g-dev
  pyenv install "$version"
  pyenv global "$version"  # creates ~/.pyenv/version
  pyenv exec pip install --user pipx
  pipx install uv
}
