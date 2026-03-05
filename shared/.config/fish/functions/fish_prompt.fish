# Requires https://nerdfonts.com
# See https://github.com/fish-shell/fish-shell/blob/master/share/functions/fish_prompt.fish
function fish_prompt -d 'Write out the prompt'
  # colors
  # https://fishshell.com/docs/current/cmds/set_color.html
  set -l color_duration black
  set -l color_git green
  set -l color_python blue

  # prompt chars from https://github.com/IlanCosman/tide
  set -l char_prompt_top '╭─'
  set -l char_prompt_bottom '╰─'

  # icons
  set -l icon_git '󰊢' # nf-md-git
  set -l icon_python '󰌠' # nf-md-language_python

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

    # command duration colors
    test $last_cmd_duration -gt 49 ; and test $last_cmd_duration -lt 60000 ; and set color_duration yellow
    test $last_cmd_duration -gt 59999 ; and set color_duration red

    # setting these to be the same so the next prompt is cleared if no exit code is returned
    set -g __last_status_generation $status_generation

    # same logic as `__fish_print_pipestatus`
    # SIGPIPE (128 + 13) is not treated as an error
    if not contains -- $__fish_last_status 0 141
      set color_prompt $fish_color_error
    end
  end

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
  set -l template ''
  set template $template$(set_color $color_git)$icon_git' '
  fish_git_prompt $template'%s '

  # python
  set -q VIRTUAL_ENV ; and begin
    echo -ns (set_color $color_python)$icon_python' '
  end

  # command duration and exit status
  if test "$show_status" = true
    if test $last_cmd_duration -gt 0 ; and type -q format
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
