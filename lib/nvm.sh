# shellcheck shell=bash
# installs nvm and node (lts if not specified)
dotfiles_nvm() {
  local version=${1:-'lts/*'}
  local nvm_dir="${HOME}/.nvm"

  rm -rf "$nvm_dir"
  git clone --depth=1 https://github.com/nvm-sh/nvm.git "$nvm_dir"

  unset NVM_DIR
  source "${nvm_dir}/nvm.sh" --no-use
  nvm install "$version"
  nvm alias default "$version"
}
