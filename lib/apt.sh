# shellcheck shell=bash
df_apt() {
  if [ "$(uname)" != 'Linux' ] ; then
    echo "df_apt: Unsupported OS $(uname -s)"
    return 1
  fi

  local -a args=("$@")
  local cwd="${BASH_SOURCE[0]:-$0}"
  source "$(dirname "$(realpath "$cwd")")/util/with_sudo.sh"

  # the Ubuntu images are "minimized" so they don't include (or download) man pages
  # you can run `sudo unminimize` but this reinstalls every package and takes minutes
  # these steps restore man functionality without reinstalling packages
  # use `sudo apt install --reinstall` to reinstall a package
  [ -e /etc/dpkg/dpkg.cfg.d/excludes ] && with_sudo rm -f /etc/dpkg/dpkg.cfg.d/excludes
  [ -e /etc/update-motd.d/60-unminimize ] && with_sudo rm -f /etc/update-motd.d/60-unminimize

  if [ "$(dpkg-divert --truename /usr/bin/man)" = "/usr/bin/man.REAL" ] ; then
    # remove diverted man binary
    with_sudo rm -f /usr/bin/man
    with_sudo dpkg-divert --quiet --remove --rename /usr/bin/man
  fi

  # don't download man page translations when installing packages
  if [ ! -e /etc/apt/apt.conf.d/99translations ] ; then
    with_sudo mkdir -p /etc/apt/apt.conf.d
    echo 'Acquire::Languages "none";' | with_sudo tee /etc/apt/apt.conf.d/99translations >/dev/null
  fi

  with_sudo apt-get update

  # install packages
  if [ "${#args[@]}" -ne 0 ] ; then
    export DEBIAN_FRONTEND=noninteractive
    with_sudo apt-get install -y --no-install-recommends "${args[@]}" | grep -v 'warning: ' # ignore update-alternatives warnings
    unset DEBIAN_FRONTEND
  fi
}
