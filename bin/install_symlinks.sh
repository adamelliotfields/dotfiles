#!/usr/bin/env bash
set -euo pipefail

# Symlinks files into $HOME.
main() {
  local verbose=0
  if [[ "${1:-}" == '-v' || "${1:-}" == '--verbose' ]] ; then
    verbose=1
    shift
  fi

  local os
  os="$(uname -s)"

  local -a srcs=()
  if [[ "$os" == 'Darwin' ]] ; then
    srcs=('shared' 'mac')
  elif [[ "$os" == 'Linux' ]] ; then
    srcs=('shared' 'linux')
  else
    echo "install_symlinks: Unsupported OS '$os'"
    return 1
  fi

  local script_dir
  script_dir="$(dirname "${BASH_SOURCE[0]}")"

  local src src_dir
  for src in "${srcs[@]}" ; do
    # Source folders are one level up from this script.
    src_dir="$(realpath "$script_dir/../$src")"

    if [[ ! -d "$src_dir" ]] ; then
      echo "install_symlinks: Cannot find source folder '$src_dir'"
      return 1
    fi

    find "$src_dir" -type f -print0 | while IFS= read -r -d '' file ; do
      # /path/to/.bashrc --> .bashrc
      # /path/to/.config/fish/config.fish --> .config/fish/config.fish
      local dest_file dest_path dest_dir file_path
      dest_file="${file#"$src_dir"/}"
      dest_path="${HOME:?}/$dest_file"
      dest_dir="$(dirname "$dest_path")"
      file_path="$(realpath "$file")"

      if [[ -e "$dest_path" && ! -L "$dest_path" ]] ; then
        mv "$dest_path" "${dest_path}.bak"
        if [[ "$verbose" -eq 1 ]] ; then
          echo "mv       $dest_path ${dest_path}.bak"
        fi
      fi

      mkdir -p "$dest_dir"
      if [[ "$verbose" -eq 1 ]] ; then
        echo "mkdir -p $dest_dir"
      fi

      ln -sf "$file_path" "$dest_path"
      if [[ "$verbose" -eq 1 ]] ; then
        echo "ln -s    $file_path $dest_path"
      fi
    done
  done
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]] ; then
  main "$@"
fi
