# shellcheck shell=bash
# symlinks the files in the provided folders to the user's home folder while preserving the directory structure
# @example HOME=$(mktemp -d) dotfiles_link
function dotfiles_link {
  local os="$(uname -s)"
  local srcs=()
  if [[ $os == 'Darwin' ]] ; then
    srcs=('shared' 'mac')
  elif [[ $os == 'Linux' ]] ; then
    srcs=('shared' 'linux')
  else
    echo "dotfiles_link: Unsupported OS '$os'"
    return 1
  fi

  for src in "${srcs[@]}" ; do
    func_dir="$(dirname "${BASH_SOURCE[0]}")"

    # source folders are 1-up from this file
    # note that `realpath` was just added to macOS in Ventura (late '22)
    src_dir="$(realpath "$func_dir/../$src")"

    # error if the source folder doesn't exist
    if [[ ! -d "${src_dir}" ]] ; then
      echo "dotfiles_link: Cannot find source folder '${src_dir}'"
      return 1
    fi

    # handle spaces in names
    find "$src_dir" -type f -print0 | while IFS= read -r -d '' file ; do
      # trim the source directory from the beginning of the file path
      # ex: /path/to/.bashrc --> .bashrc
      # ex: /path/to/.config/fish/config.fish --> .config/fish/config.fish
      local dest_file="${file#"$src_dir"/}"
      local dest_path="${HOME:?}/${dest_file}"
      local dest_dir="$(dirname "$dest_path")"
      local file_path="$(realpath "$file")"

      # check if the file exists and is not a symlink
      if [[ -e "$dest_path" && ! -L "$dest_path" ]] ; then
        # backup the existing file
        mv "$dest_path" "${dest_path}.bak"
        echo "${dest_path} --> ${dest_path}.bak"
      fi

      # create the target directory
      mkdir -p "$dest_dir"

      # create the symlink
      ln -sf "$file_path" "$dest_path"
      echo "${file_path} --> ${dest_path}"
    done
  done
}
