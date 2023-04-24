# Fish prompt by @adamelliotfields 🐟
# See $HOMEBREW_PREFIX/share/fish/functions/fish_prompt.fish for the default prompt
function fish_prompt --description 'Write out the prompt'
  # icons
  set -l nf_fa_key \uf084           # 
  set -l nf_fa_chevron_right \uf054 # 
  set -l nf_fa_hashtag \uf292       # 

  # exit status including pipe status
  set -lx __fish_last_status $status # local export for __fish_print_pipestatus
  set -l __fish_last_status_error 0
  set -l __last_pipestatus $pipestatus
  set -q __fish_prompt_status_generation
    or set -g __fish_prompt_status_generation $status_generation

  # show user@host only in a SSH session
  #   - user: $fish_color_user
  #   - host: $fish_color_host_remote
  if set -q SSH_TTY
    printf '%s%s' (prompt_login) ' '
  end

  # pwd
  printf '%s%s%s%s' (set_color $fish_color_cwd) (prompt_pwd) ' ' (set_color normal)

  # git signing key
  set -l signingkey (git config --global user.signingkey 2>/dev/null)
  if test -n "$signingkey"
    printf '%s%b%s%s' (set_color yellow) $nf_fa_key ' ' (set_color normal)
  end

  # git email
  set -l email (git config --global user.email 2>/dev/null)
  if test -n "$email"
    printf '%s%s%s' (set_color cyan) $email (set_color normal)
  end

  # git status
  # https://fishshell.com/docs/current/cmds/fish_git_prompt.html
  printf '%s%s%s' (fish_git_prompt) ' ' (set_color normal)

  # $status_generation increments when the previous command returned a status code
  if test $__fish_prompt_status_generation -ne $status_generation
    __fish_print_pipestatus '[' '] ' '|' (set_color $fish_color_normal) (set_color $fish_color_error) $__last_pipestatus
    set -g __fish_prompt_status_generation $status_generation
    if not contains $__fish_last_status 0 141
      set __fish_last_status_error 1
    end
  end

  # command duration (requires jorgebucaran/humantime.fish)
  if type -q humantime
    printf '%s%s%s%s' (set_color $fish_color_autosuggestion) (humantime $CMD_DURATION) ' ' (set_color normal)
  end

  # set prompt character color
  test $__fish_last_status_error -eq 1
    and set_color $fish_color_error
    or set_color $fish_color_normal

  # set prompt character
  set -l __fish_prompt_char $nf_fa_chevron_right
  fish_is_root_user
    and set __fish_prompt_char $nf_fa_hashtag

  printf '%b%b%s' '\n' $__fish_prompt_char ' ' (set_color normal)
end
