# shellcheck shell=bash
df_go() {
  local version=$(curl -fsSL https://go.dev/VERSION?m=text)
  local arch=''
  local os=''

  local cwd="${BASH_SOURCE[0]:-$0}"
  source "$(dirname "$(realpath "$cwd")")/util/with_sudo.bash"

  # set arch
  case "$(uname -m)" in
    aarch64|arm64) arch='arm64' ;;
    x86_64|amd64)  arch='amd64' ;;
    *)             echo "df_go: unsupported architecture: $(uname -m)"; return 1 ;;
  esac

  # set os
  case "$(uname -s)" in
    Darwin) os='darwin' ;;
    Linux)  os='linux' ;;
    *)      echo "df_go: unsupported os: $(uname -s)"; return 1 ;;
  esac

  local filename="${version}.${os}-${arch}.tar.gz"

  wget -nv -O "/tmp/${filename}" "https://golang.org/dl/${filename}"
  with_sudo tar -C /usr/local -xzf "/tmp/${filename}"
  rm -f "/tmp/${filename}"
}
