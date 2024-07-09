#!/usr/bin/env bash
# undoes `link.sh`
function dotfiles_clean {
  local verbose=false
  local os="$(uname -s)"
  local srcs=()

  # check for -v/--verbose flags
  if [[ ${1:-} == '-v' || ${1:-} == '--verbose' ]] ; then
    verbose=true
    shift
  fi

  if [[ $os == 'Darwin' ]] ; then
    srcs=('shared' 'mac')
  elif [[ $os == 'Linux' ]] ; then
    srcs=('shared' 'linux')
  else
    echo "dotfiles_clean: Unsupported OS '$os'"
    return 1
  fi

  for src in "${srcs[@]}" ; do
    func_dir="$(dirname "${BASH_SOURCE[0]}")"

    # source folders are 1-up from this file
    # note that `realpath` was just added to macOS in Ventura (late '22)
    src_dir="$(realpath "$func_dir/../$src")"

    # error if the source folder doesn't exist
    if [[ ! -d "${src_dir}" ]] ; then
      echo "dotfiles_clean: Cannot find source folder '${src_dir}'"
      return 1
    fi

    # handle spaces in names
    find "$src_dir" -type f -print0 | while IFS= read -r -d '' file ; do
      local dest_file="${file#"$src_dir"/}"
      local dest_path="${HOME:?}/${dest_file}"
      local dest_dir="$(dirname "$dest_path")"

      # check if the file is a symlink
      if [[ -L "$dest_path" ]] ; then
        # delete the symlink
        rm -f "$dest_path"
        if [[ $verbose == true ]] ; then
          echo "rm    ${dest_path}"
        fi
      fi

      # check if the file is a backup
      local bak_file="${dest_path}.bak"
      if [[ -f "$bak_file" ]] ; then
        # restore the backup
        mv "$bak_file" "$dest_path"
        if [[ $verbose == true ]] ; then
          echo "mv    ${bak_file} ${dest_path}"
        fi
      fi

      # check if the directory is empty
      if [[ -d "$dest_dir" ]] ; then
        if [[ -z "$(ls -A "$dest_dir")" ]] ; then
          # delete the directory
          rm -rf "$dest_dir"
          if [[ $verbose == true ]] ; then
            echo "rm -r ${dest_dir}"
          fi
        fi
      fi
    done
  done
}

# if not sourced
if [[ ${BASH_SOURCE[0]} = "$0" ]] ; then
  dotfiles_clean "$@"
fi
