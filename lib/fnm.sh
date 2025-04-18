# installs fast node manager (linux only)
function dotfiles_fnm {
  source "$(dirname "${BASH_SOURCE[0]}")/sudo.sh"

  # use homebrew on mac
  if [[ "$(uname -s)" != 'Linux' ]] ; then
    echo 'dotfiles_deb: Unsupported OS'
    return 1
  fi

  local url='https://github.com/Schniz/fnm/releases/latest/download'
  local fnm_zip=''

  case "$(uname -m)" in
    aarch64|arm64) fnm_zip='fnm-arm64.zip' ;;
    x86_64|amd64)  fnm_zip='fnm-linux.zip' ;;
    *)             echo 'dotfiles_fnm: Unsupported architecture' ; return 1 ;;
  esac

  # install
  rm -f "/tmp/${fnm_zip}"
  wget -qO "/tmp/${fnm_zip}" "${url}/${fnm_zip}"
  dotfiles_sudo unzip -qod /usr/local/bin "/tmp/${fnm_zip}"
  dotfiles_sudo chmod +x /usr/local/bin/fnm

  # completions
  local bash_completions='/etc/bash_completion.d/fnm'
  dotfiles_sudo rm -f $bash_completions
  fnm completions --shell=bash | dotfiles_sudo tee $bash_completions >/dev/null

  # cleanup
  rm -f "/tmp/${fnm_zip}"
}
