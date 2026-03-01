# configures apt and installs packages if specified (linux only)
function dotfiles_apt {
  # run as sudo if not root
  function _sudo {
    [[ $EUID -ne 0 ]] && sudo "$@" || "$@"
  }

  local -a args=("$@")

  if [[ -z $(command -v apt 2>/dev/null) || $(uname -s) != 'Linux' ]] ; then
    echo 'dotfiles_apt: Unsupported OS'
    return 1
  fi

  # Ubuntu images can be "minimized" so they don't download man pages
  # you can run `sudo unminimize` but this reinstalls every package
  # these steps restore man functionality without reinstalling packages
  # use `sudo apt install --reinstall` to reinstall a package and download its man page
  [[ -f /etc/dpkg/dpkg.cfg.d/excludes ]] && _sudo rm -f /etc/dpkg/dpkg.cfg.d/excludes
  [[ -f /etc/update-motd.d/60-unminimize ]] && _sudo rm -f /etc/update-motd.d/60-unminimize

  if [[ $(dpkg-divert --truename /usr/bin/man) == '/usr/bin/man.REAL' ]] ; then
    # remove diverted man binary
    _sudo rm -f /usr/bin/man
    _sudo dpkg-divert --quiet --remove --rename /usr/bin/man
  fi

  # don't download man page translations when installing packages
  if [[ ! -f /etc/apt/apt.conf.d/99translations ]] ; then
    _sudo mkdir -p /etc/apt/apt.conf.d
    echo 'Acquire::Languages "none";' | _sudo tee /etc/apt/apt.conf.d/99translations >/dev/null
  fi

  # install packages
  if [[ "${#args[@]}" -ne 0 ]] ; then
    _sudo apt-get update
    _sudo apt-get install -y --no-install-recommends "${args[@]}" | grep -v 'warning: ' # ignore update-alternatives warnings
  fi
}
