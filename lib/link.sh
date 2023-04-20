# shellcheck shell=bash
df_link() {
  local home="${HOME:?}"
  local cwd="${BASH_SOURCE[0]:-$0}"
  # use `dirname` twice to get the parent directory
  local root="$(dirname "$(dirname "$(realpath "$cwd")")")"
  local -a srcs=()

  case "$(uname -s)" in
    Darwin) srcs=("${root}/shared" "${root}/mac") ;;
    Linux)  srcs=("${root}/shared" "${root}/linux") ;;
    *)      srcs=("${root}/shared") ;;
  esac

  # loop over each dir and symlink the files
  for src in "${srcs[@]}" ; do
    # skip if the source directory does not exist
    if [ ! -d "${src}" ] ; then
      continue
    fi

    # need to handle spaces in names
    find "$src" -type f -print0 | while IFS= read -r -d '' file ; do
      local dest="${home}/${file#"$src"/}"
      local dest_dir="$(dirname "$dest")"
      echo "-> ${dest}"

      # check if the file exists and is not a symlink
      if [[ -e "$dest" && ! -L "$dest" ]] ; then
        # Backup the existing file
        mv "$dest" "${dest}.bak"
      fi

      # create the target directory
      mkdir -p "$dest_dir"

      # create the symlink
      ln -sf "$file" "$dest"
    done
  done
}
