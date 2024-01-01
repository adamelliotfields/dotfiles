# Fish prompt by @adamelliotfields 🐟
# Requires https://nerdfonts.com
# See https://github.com/fish-shell/fish-shell/blob/master/share/functions/fish_prompt.fish
function fish_prompt -d 'Write out the prompt'
  # colors
  # https://fishshell.com/docs/current/cmds/set_color.html
  set -l color_k8s blue
  set -l color_k8s_context brblack
  set -l color_git green
  set -l color_git_key yellow
  set -l color_git_email brblack
  set -l color_duration black
  set -l color_docker $color_k8s
  set -l color_python $color_k8s

  # prompt chars from https://github.com/IlanCosman/tide
  set -l char_prompt_top '╭─'
  set -l char_prompt_bottom '╰─'

  # icons
  set -l icon_git '󰊢' # nf-md-git
  set -l icon_key '󰌆' # nf-md-key
  set -l icon_k8s '󱃾' # nf-md-kubernetes
  set -l icon_docker '󰡨' # nf-md-docker
  set -l icon_python '󰌠' # nf-md-language_python

  # features
  set -l show_git false # toggled by FISH_PROMPT_GIT=<0|1>
  set -l show_git_user false # toggled by FISH_PROMPT_GIT_USER=<0|1>
  set -l show_k8s false # toggled by FISH_PROMPT_K8S=<0|1>
  set -l show_docker false # toggled by FISH_PROMPT_DOCKER=<0|1>

  # $status is the exit code of the last command (i.e., $? in bash)
  # $pipestatus is an array of exit codes for each command in a pipe
  set -lx __fish_last_status $status # local export for `__fish_print_pipestatus`
  set -l last_pipestatus $pipestatus
  set -l last_cmd_duration $CMD_DURATION

  # $status_generation is a counter that increments if the last command returned an exit code
  not set -q __last_status_generation ; and set -g __last_status_generation $status_generation
  set -l color_prompt $fish_color_normal
  set -l show_status false
  if test $__last_status_generation -ne $status_generation
    set show_status true

    # command duration colors (not using)
    # test $last_cmd_duration -gt 49 ; and test $last_cmd_duration -lt 60000 ; and set color_duration yellow
    # test $last_cmd_duration -gt 59999 ; and set color_duration red

    # setting these to be the same so the next prompt is cleared if no exit code is returned
    set -g __last_status_generation $status_generation

    # same logic as `__fish_print_pipestatus`
    # SIGPIPE (128 + 13) is not treated as an error
    if not contains -- $__fish_last_status 0 141
      set color_prompt $fish_color_error
    end
  end

  # set these after reading $status as they do return an exit code
  set -q FISH_PROMPT_GIT ; and contains -- $FISH_PROMPT_GIT 1 true ; and set show_git true
  set -q FISH_PROMPT_GIT_USER ; and contains -- $FISH_PROMPT_GIT_USER 1 true ; and set show_git_user true
  set -q FISH_PROMPT_K8S ; and contains -- $FISH_PROMPT_K8S 1 true ; and set show_k8s true
  set -q FISH_PROMPT_DOCKER ; and contains -- $FISH_PROMPT_DOCKER 1 true ; and set show_docker true

  # prefix
  echo -ns (set_color $color_prompt) $char_prompt_top ' '

  # login
  # https://fishshell.com/docs/current/cmds/prompt_login.html
  set -q SSH_TTY ; and echo -ns (prompt_login) ' '

  # pwd
  # https://fishshell.com/docs/current/cmds/prompt_pwd.html
  set -l color_pwd $fish_color_cwd
  fish_is_root_user ; and set color_pwd $fish_color_cwd_root
  echo -ns (set_color $color_pwd) (prompt_pwd) ' '

  # git
  # variables are set in ../conf.d/fish_git_prompt.fish
  # https://fishshell.com/docs/current/cmds/fish_git_prompt.html
  if test "$show_git" = true
    # build a template to pass to `fish_git_prompt`
    # which calls `git rev-parse` to check if we're in a repo
    set -l template ''

    # git user
    if test "$show_git_user" = true
      # signing key
      set -l signingkey (git config --global user.signingkey 2>/dev/null)
      if test -n "$signingkey"
        set template $template$(set_color $color_git_key)$icon_key' '
      end

      # email
      set -l email (git config --global user.email 2>/dev/null)
      if test -n "$email"
        set template $template$(set_color $color_git_email)$email' '
      end
    end

    # git status
    set template $template$(set_color $color_git)$icon_git' '
    fish_git_prompt $template'%s '
  end

  # python
  set -q VIRTUAL_ENV ; and begin
    echo -ns (set_color $color_python)$icon_python' '
  end

  # kubernetes
  if test "$show_k8s" = true ; and command -v kubectl >/dev/null
    set -l k8s_context (kubectl config view --minify --output 'jsonpath={.current-context}:{..namespace}' | string trim -r -c ':' 2>/dev/null)

    if test -n "$k8s_context"
      echo -ns (set_color $color_k8s) $icon_k8s ' ' (set_color $color_k8s_context) $k8s_context ' '
    end
  end

  # docker
  # https://gist.github.com/nuxlli/7553996
  if test "$show_docker" = true ; and echo -n 'GET /info HTTP/1.0\r\n\r\n' | nc -U ~/.docker/run/docker.sock &>/dev/null # /var/run/docker.sock is a symlink on mac
    echo -ns (set_color $color_docker) $icon_docker ' '
  end

  # command duration and exit status
  if test "$show_status" = true
    if test $last_cmd_duration -gt 0
      echo -ns (set_color $color_duration) (format -t $last_cmd_duration) ' '
    end

    # prints nothing if the last command returned an exit code of 0 or 141
    # converts the exit code to a string if applicable
    # e.g., "143" is printed as "SIGTERM" (128 + 15)
    __fish_print_pipestatus '[' '] ' '|' (set_color $fish_color_normal) (set_color $fish_color_error) $last_pipestatus
  end

  # newline prompt
  echo -ns \n (set_color $color_prompt) $char_prompt_bottom (set_color normal) ' '
end
