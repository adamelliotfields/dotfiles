# shellcheck shell=bash
# symlinks the files in the provided folders to the user's home folder while preserving the directory structure
# @example HOME=$(mktemp -d) dotfiles_link shared linux
# @example HOME=$(mktemp -d) dotfiles_link ./shared ./linux
# @example HOME=$(mktemp -d) dotfiles_link $(realpath shared) $(realpath linux)
function dotfiles_link {
  local srcs=("$@")

  for src in "${srcs[@]}" ; do
    # skip if the source directory does not exist
    if [[ ! -d "${src}" ]] ; then
      continue
    fi

    # handle spaces in names
    find "$src" -type f -print0 | while IFS= read -r -d '' file ; do
      # trim the source directory from the beginning of the file path
      # ex: /path/to/.bashrc --> .bashrc
      # ex: /path/to/.config/fish/config.fish --> .config/fish/config.fish
      local dest_file="${file#"$src"/}"
      local dest_path="${HOME:?}/${dest_file}"
      local dest_dir="$(dirname "$dest_path")"

      # note that `realpath` was just added to macOS in Ventura (late '22)
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
