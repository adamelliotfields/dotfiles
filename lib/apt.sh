#!/usr/bin/env bash
# configures apt and installs packages if specified (linux only)
function dotfiles_apt {
  local -a args=("$@")

  if [[ -z $(command -v apt 2>/dev/null) || $(uname -s) != 'Linux' ]] ; then
    echo 'dotfiles_apt: Unsupported OS'
    return 1
  fi

  # the Ubuntu images are "minimized" so they don't include (or download) man pages
  # you can run `sudo unminimize` but this reinstalls every package and takes minutes
  # these steps restore man functionality without reinstalling packages (i.e., new packages will get man pages)
  # use `sudo apt install --reinstall` to reinstall a package and download its man page
  [[ -e /etc/dpkg/dpkg.cfg.d/excludes ]] && sudo rm -f /etc/dpkg/dpkg.cfg.d/excludes
  [[ -e /etc/update-motd.d/60-unminimize ]] && sudo rm -f /etc/update-motd.d/60-unminimize

  if [[ $(dpkg-divert --truename /usr/bin/man) == '/usr/bin/man.REAL' ]] ; then
    # remove diverted man binary
    sudo rm -f /usr/bin/man
    sudo dpkg-divert --quiet --remove --rename /usr/bin/man
  fi

  # don't download man page translations when installing packages
  if [[ ! -s /etc/apt/apt.conf.d/99translations ]] ; then
    sudo mkdir -p /etc/apt/apt.conf.d
    echo 'Acquire::Languages "none";' | sudo tee /etc/apt/apt.conf.d/99translations >/dev/null
  fi

  # install packages
  if [[ "${#args[@]}" -ne 0 ]] ; then
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends "${args[@]}" | grep -v 'warning: ' # ignore update-alternatives warnings
  fi
}

# if not sourced
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
  dotfiles_apt "$@"
fi
