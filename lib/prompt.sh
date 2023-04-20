# shellcheck shell=bash
df_prompt() {
  local home="${HOME:?}"
  local -a args=("$@")

  for prompt in "${args[@]}" ; do
    # you can use `#` because the format will always be `user/repo` (one slash)
    # if the format was `path/to/repo` then you would use `##` (many slashes)
    local dest=".${prompt#*/}"
    local branch='main'

    # liquidprompt has a special branch
    if [ "$prompt" = 'nojhan/liquidprompt' ] ; then
      branch='stable'
    fi

    rm -rf "${home:?}/${dest}"
    git clone --depth=1 --branch="$branch" "https://github.com/${prompt}.git" "${home}/${dest}"
  done
}
