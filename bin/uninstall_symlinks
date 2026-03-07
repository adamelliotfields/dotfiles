#!/usr/bin/env bash
set -euo pipefail

# Removes dotfile symlinks and restores backed up files.
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
    echo "uninstall_symlinks: Unsupported OS '$os'"
    return 1
  fi

  local script_dir
  script_dir="$(dirname "${BASH_SOURCE[0]}")"

  local src src_dir
  for src in "${srcs[@]}" ; do
    # Source folders are one level up from this script.
    src_dir="$(realpath "$script_dir/../$src")"

    if [[ ! -d "$src_dir" ]] ; then
      echo "uninstall_symlinks: Cannot find source folder '$src_dir'"
      return 1
    fi

    find "$src_dir" -type f -print0 | while IFS= read -r -d '' file ; do
      local dest_file dest_path dest_dir bak_file
      dest_file="${file#"$src_dir"/}"
      dest_path="${HOME:?}/$dest_file"
      dest_dir="$(dirname "$dest_path")"

      if [[ -L "$dest_path" ]] ; then
        rm -f "$dest_path"
        if [[ "$verbose" -eq 1 ]] ; then
          echo "rm    $dest_path"
        fi
      fi

      bak_file="${dest_path}.bak"
      if [[ -f "$bak_file" ]] ; then
        mv "$bak_file" "$dest_path"
        if [[ "$verbose" -eq 1 ]] ; then
          echo "mv    $bak_file $dest_path"
        fi
      fi

      if [[ -d "$dest_dir" ]] && [[ -z "$(ls -A "$dest_dir")" ]] ; then
        rm -rf "$dest_dir"
        if [[ "$verbose" -eq 1 ]] ; then
          echo "rm -r $dest_dir"
        fi
      fi
    done
  done
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]] ; then
  main "$@"
fi
