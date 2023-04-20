# customize the prompt
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showcolorhints 1
set -g __fish_git_prompt_color $fish_color_normal
set -g __fish_git_prompt_color_prefix $fish_color_normal
set -g __fish_git_prompt_color_suffix $fish_color_normal
set -g __fish_git_prompt_color_cleanstate --bold green
set -g __fish_git_prompt_color_dirtystate --bold red
set -g __fish_git_prompt_color_invalidstate --bold red
set -g __fish_git_prompt_color_stagedstate --bold green
set -g __fish_git_prompt_color_stashstate --bold blue
set -g __fish_git_prompt_color_untrackedfiles --bold yellow
set -g __fish_git_prompt_color_upstream --bold white
set -g __fish_git_prompt_char_stateseparator '|'
set -g __fish_git_prompt_char_cleanstate \uf00c       #  nf-fa-check
set -g __fish_git_prompt_char_dirtystate \uf12a       #  nf-fa-exclamation
set -g __fish_git_prompt_char_invalidstate \uf00d     #  nf-fa-close
set -g __fish_git_prompt_char_stagedstate \uf067      #  nf-fa-plus
set -g __fish_git_prompt_char_stashstate \uf155       #  nf-fa-dollar
set -g __fish_git_prompt_char_untrackedfiles \uf128   #  nf-fa-question
set -g __fish_git_prompt_char_upstream_ahead \uf062   #  nf-fa-arrow-up
set -g __fish_git_prompt_char_upstream_behind \uf063  #  nf-fa-arrow-down
set -g __fish_git_prompt_char_upsteam_diverged \uf07d #  nf-fa-arrows_v
set -g __fish_git_prompt_char_upstream_equal \ue279   #  nf-fae-equal
