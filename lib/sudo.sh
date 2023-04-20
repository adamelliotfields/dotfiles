# shellcheck shell=bash
df_sudo() {
  local cwd="${BASH_SOURCE[0]:-$0}"
  source "$(dirname "$(realpath "$cwd")")/util/with_sudo.bash"

  # create /etc/sudoers.d/$user if it does not exist
  if [ ! -e "/etc/sudoers.d/$USER" ] ; then
    with_sudo mkdir -p /etc/sudoers.d
    echo "$USER ALL=(ALL) NOPASSWD:ALL" | with_sudo tee "/etc/sudoers.d/$USER" >/dev/null
  fi
}
