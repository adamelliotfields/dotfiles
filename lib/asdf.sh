# shellcheck shell=bash
df_asdf() {
  # exit if $HOME is not set
  local dest="${HOME:?}/.asdf"
  local -a args=("$@")

  rm -rf "$dest"
  git clone --depth=1 https://github.com/asdf-vm/asdf.git "$dest"

  if [ "${#args[@]}" -ne 0 ] ; then
    source "$dest/asdf.sh"
    for plugin in "${args[@]}" ; do
      asdf plugin add "$plugin"
      asdf install "$plugin" latest
      asdf global "$plugin" latest
    done
  fi
}
