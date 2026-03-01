# installs uv (linux only)
function dotfiles_uv {
  # run as sudo if not root
  function _sudo {
    [[ $EUID -ne 0 ]] && sudo "$@" || "$@"
  }

  if [[ "$(uname -s)" != 'Linux' ]] ; then
    echo 'dotfiles_uv: Unsupported OS'
    return 1
  fi

  local uv_dir=''
  case "$(uname -m)" in
    aarch64|arm64) uv_dir='uv-aarch64-unknown-linux-gnu' ;;
    x86_64|amd64)  uv_dir='uv-x86_64-unknown-linux-gnu' ;;
    *)             echo 'dotfiles_uv: Unsupported architecture' ; return 1 ;;
  esac

  local uv_tar="${uv_dir}.tar.gz"
  local url='https://github.com/astral-sh/uv/releases/latest/download'

  # install
  rm -rf "/tmp/${uv_tar}" "/tmp/${uv_dir}"
  wget -qO "/tmp/${uv_tar}" "${url}/${uv_tar}"
  tar -C /tmp -xzf "/tmp/${uv_tar}"
  _sudo cp -af "/tmp/${uv_dir}/uv" /usr/local/bin
  _sudo cp -af "/tmp/${uv_dir}/uvx" /usr/local/bin
  _sudo chmod +x /usr/local/bin/uv /usr/local/bin/uvx

  # completions (no uvx)
  local bash_completions='/etc/bash_completion.d/uv'
  _sudo rm -f $bash_completions
  uv generate-shell-completion bash | _sudo tee $bash_completions >/dev/null

  # cleanup
  rm -rf "/tmp/${uv_tar}" "/tmp/${uv_dir}"
}
