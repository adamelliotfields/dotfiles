# shellcheck shell=bash
# installs go
function dotfiles_go {
  local version=$(curl -fsSL https://go.dev/VERSION?m=text)
  local arch=''
  local os=''

  # set arch
  case "$(uname -m)" in
    aarch64|arm64) arch='arm64' ;;
    x86_64|amd64)  arch='amd64' ;;
    *)             echo 'dotfiles_go: Unsupported architecture' ; return 1 ;;
  esac

  # set os
  case "$(uname -s)" in
    Darwin) os='darwin' ;;
    Linux)  os='linux' ;;
    *)      echo 'dotfiles_go: Unsupported OS' ; return 1 ;;
  esac

  local filename="${version}.${os}-${arch}.tar.gz"

  wget -nv -O "/tmp/${filename}" "https://golang.org/dl/${filename}"
  sudo tar -C /usr/local -xzf "/tmp/${filename}"
  rm -f "/tmp/${filename}"
}
