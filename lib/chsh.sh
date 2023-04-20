# shellcheck shell=bash
df_chsh() {
  local shell=${1:-/bin/zsh}
  local cwd="${BASH_SOURCE[0]:-$0}"
  source "$(dirname "$(realpath "$cwd")")/util/with_sudo.bash"

  # add shell to /etc/shells if not already there
  if ! grep -q "$shell" /etc/shells ; then
    echo "$shell" | with_sudo tee -a /etc/shells >/dev/null
  fi

  # change shell for current user
  chsh -s "$shell"
}
