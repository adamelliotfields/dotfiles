# installs bun
dotfiles_bun() {
  source "$(dirname "${BASH_SOURCE[0]}")/sudo.sh"

  local url='https://github.com/oven-sh/bun/releases/latest/download'
  local target=''

  # set target
  case "$(uname -ms)" in
    'Darwin x86_64')                 target='darwin-x64' ;;
    'Darwin arm64')                  target='darwin-aarch64' ;;
    'Linux x86_64')                  target='linux-x64' ;;
    'Linux aarch64' | 'Linux arm64') target='linux-aarch64' ;;
    *)                               echo 'dotfiles_bun: Unsupported target' ; return 1 ;;
  esac

  # if darwin-x64 check if we're in Rosetta
  if [[ $target == 'darwin-x64' ]] ; then
    if [[ $(sysctl -n sysctl.proc_translated 2>/dev/null) -eq 1 ]] ; then
      echo 'dotfiles_bun: Rosetta detected; installing aarch64'
      target='darwin-aarch64'
    fi
  fi

  # if AVX2 isn't supported use the -baseline build
  if [[ $target == 'darwin-x64' ]] ; then
    if [[ $(sysctl -a | grep machdep.cpu | grep AVX2) == '' ]] ; then
      target='darwin-x64-baseline'
    fi
  elif [[ $target == 'linux-x64' ]] ; then
    if ! grep -q avx2 /proc/cpuinfo ; then
      target='linux-x64-baseline'
    fi
  fi

  # download the zip
  local file_name="bun-${target}.zip"
  local dest_file_name='/tmp/bun.zip'
  rm -f "$dest_file_name"
  wget -qO "$dest_file_name" "${url}/${file_name}"

  # install to ~/.bun
  local bun_dir="${HOME}/.bun"
  local bun_bin_dir="${bun_dir}/bin"
  unzip -qod /tmp "$dest_file_name"
  rm -rf "$bun_dir"
  mkdir -p "$bun_bin_dir"
  mv "/tmp/bun-${target}/bun" "$bun_bin_dir"
  chmod +x "${bun_bin_dir}/bun"

  # cleanup
  rm -rf "/tmp/bun-${target}"
  rm -f /tmp/bun.zip
}
