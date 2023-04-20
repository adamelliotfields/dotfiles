# Fish prompt by @adamelliotfields 🐟
# See /usr/local/share/fish/functions/fish_prompt.fish for the default prompt
function fish_prompt --description 'Write out the prompt'
  set -lx __fish_last_status $status # export for __fish_print_pipestatus
  set -l __fish_last_status_error 0
  set -l __last_pipestatus $pipestatus
  set -l __fish_prompt_char \uf054 #  nf-fa-chevron_right
  set -q __fish_prompt_status_generation
    or set -g __fish_prompt_status_generation $status_generation

  # Show user@host only in a SSH session
  # User color: $fish_color_user
  # Host color: $fish_color_host_remote
  if set -q SSH_TTY
    printf '%s%s' (prompt_login) ' '
  end

  # PWD
  printf '%s%s%s' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)

  # Git
  # See https://fishshell.com/docs/current/cmds/fish_git_prompt.html
  printf '%s%s%s' (fish_git_prompt) ' ' (set_color normal)

  # Status
  # The `$status_generation` variable increments when the previous command returned a status code.
  if [ $__fish_prompt_status_generation != $status_generation ]
    __fish_print_pipestatus '[' '] ' '|' (set_color $fish_color_normal) (set_color $fish_color_error) $__last_pipestatus
    set -g __fish_prompt_status_generation $status_generation
    if not contains $__fish_last_status 0 141
      set __fish_last_status_error 1
    end
  end

  # Command duration (requires jorgebucaran/humantime.fish)
  if type -q humantime
    printf '%s%s%s%s' (set_color $fish_color_autosuggestion) (humantime $CMD_DURATION) ' ' (set_color normal)
  end

  # Newline prompt character
  test $__fish_last_status_error -eq 1
    and set_color $fish_color_error
    or set_color $fish_color_normal
  fish_is_root_user
    and set __fish_prompt_char \uf292 #  nf-fa-hashtag
  printf '%b%b%s' '\n' $__fish_prompt_char ' '
  set_color normal
end
