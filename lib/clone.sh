# clones github repos to ~/.${repo}
function dotfiles_clone {
  local -a repos=("$@")

  for repo in "${repos[@]}" ; do
    # you can use `#` because the format will always be `user/repo` (one slash)
    # if the format was `path/to/repo` then you would use `##` (many slashes)
    local dest=".${repo#*/}"
    local branch='main'

    if [[ "$repo" == 'nojhan/liquidprompt' ]] ; then
      branch='stable'
    fi

    rm -rf "${HOME:?}/${dest}"
    git clone --depth=1 --branch="$branch" "https://github.com/${repo}.git" "${HOME:?}/${dest}"
  done
}
