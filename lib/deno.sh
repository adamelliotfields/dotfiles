# shellcheck shell=bash
df_deno() {
  local arch=''
  local os=''

  local cwd="${BASH_SOURCE[0]:-$0}"
  source "$(dirname "$(realpath "$cwd")")/util/with_sudo.sh"

  # set arch
  case "$(uname -m)" in
    aarch64|arm64) arch='aarch64' ;;
    x86_64|amd64)  arch='x86_64' ;;
    *)             echo "df_deno: Unsupported architecture $(uname -m)" ; return 1 ;;
  esac

  # set os
  # if linux, then arch will always be x86_64
  case "$(uname -s)" in
    Darwin) os='apple-darwin' ;;
    Linux)  os='unknown-linux-gnu' ; arch='x86_64' ;;
    *)      echo "df_deno: Unsupported OS $(uname -s)" ; return 1 ;;
  esac

  local filename="deno-${arch}-${os}.zip"
  local url="https://github.com/denoland/deno/releases/latest/download/${filename}"

  # install deno
  wget -nv -O "/tmp/${filename}" "${url}"
  with_sudo unzip -od /usr/local/bin "/tmp/${filename}"
  with_sudo chmod +x /usr/local/bin/deno

  # install completions
  deno completions bash | with_sudo tee /etc/bash_completion.d/deno >/dev/null
  deno completions zsh | with_sudo tee /usr/local/share/zsh/site-functions/_deno >/dev/null

  # cleanup
  rm -f "/tmp/${filename}"
}
