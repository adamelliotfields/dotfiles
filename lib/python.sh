# shellcheck shell=bash
# installs pyenv, python, pipx, and poetry (similar toolchain to nvm/node/npx/npm)
dotfiles_python() {
  local version="$1"
  local pyenv_root="${HOME:?}/.pyenv"

  rm -rf "$pyenv_root"
  git clone --depth=1 https://github.com/pyenv/pyenv.git "$pyenv_root"
  git clone --depth=1 https://github.com/pyenv/pyenv-update.git "$pyenv_root/plugins/pyenv-update"

  PYENV_ROOT="${pyenv_root}"
  PATH="${PYENV_ROOT}/bin:${HOME}/.local/bin:${PATH}"

  [[ -z "$version" ]] && version="$(pyenv latest --known=3)"

  # requires libbz2-dev libffi-dev liblzma-dev libncurses-dev libreadline-dev libsqlite3-dev
  pyenv install "$version"
  pyenv global "$version" # creates ~/.pyenv/version
  pyenv exec pip install --user pipx
  pipx install poetry
}
