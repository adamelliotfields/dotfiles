#!/usr/bin/env bash
# installs deno
function dotfiles_deno {
  local arch=''
  local os=''
  local bash_completion_dir=''

  # set arch
  case "$(uname -m)" in
    aarch64|arm64) arch='aarch64' ;;
    x86_64|amd64)  arch='x86_64' ;;
    *)             echo 'dotfiles_deno: Unsupported architecture' ; return 1 ;;
  esac

  # set os
  # if linux, then arch will always be x86_64
  case "$(uname -s)" in
    Darwin) os='apple-darwin' ; bash_completion_dir="${HOMEBREW_PREFIX:-/usr/local}/etc/bash_completion.d" ;;
    Linux)  os='unknown-linux-gnu' ; bash_completion_dir='/etc/bash_completion.d' ; arch='x86_64' ;;
    *)      echo 'dotfiles_deno: Unsupported OS' ; return 1 ;;
  esac

  # if x86_64-apple-darwin check if we're in Rosetta
  if [[ $os == 'apple-darwin' && $arch == 'x86_64' ]] ; then
    if [[ $(sysctl -n sysctl.proc_translated 2>/dev/null) -eq 1 ]] ; then
      echo 'dotfiles_deno: Rosetta detected; installing aarch64'
      arch='aarch64'
    fi
  fi

  local filename="deno-${arch}-${os}.zip"
  local url="https://github.com/denoland/deno/releases/latest/download/${filename}"

  # install deno
  wget -qO "/tmp/${filename}" "$url"
  sudo rm -f /usr/local/bin/deno
  sudo unzip -qod /usr/local/bin "/tmp/${filename}"
  sudo chmod +x /usr/local/bin/deno

  # install completions
  sudo rm -f "${bash_completion_dir}/deno"
  sudo rm -f /usr/local/share/zsh/site-functions/_deno
  deno completions bash | sudo tee "${bash_completion_dir}/deno" >/dev/null
  deno completions zsh | sudo tee /usr/local/share/zsh/site-functions/_deno >/dev/null

  # cleanup
  rm -f "/tmp/${filename}"
}

# if not sourced
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
  dotfiles_deno "$@"
fi
