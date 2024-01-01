# customize the prompt
# https://fishshell.com/docs/current/interactive.html#syntax-highlighting-variables
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showcolorhints 1

# colors
set -g __fish_git_prompt_color $fish_color_normal
set -g __fish_git_prompt_color_prefix $fish_color_normal
set -g __fish_git_prompt_color_suffix $fish_color_normal
set -g __fish_git_prompt_color_upstream $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green
set -g __fish_git_prompt_color_dirtystate red
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_stagedstate green
set -g __fish_git_prompt_color_stashstate cyan
set -g __fish_git_prompt_color_untrackedfiles yellow

# characters
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_char_cleanstate '✓'
set -g __fish_git_prompt_char_dirtystate '!'
set -g __fish_git_prompt_char_invalidstate '⨯'
set -g __fish_git_prompt_char_stagedstate '+'
set -g __fish_git_prompt_char_stashstate '$'
set -g __fish_git_prompt_char_untrackedfiles '?'
set -g __fish_git_prompt_char_upstream_ahead '↑'
set -g __fish_git_prompt_char_upstream_behind '↓'
set -g __fish_git_prompt_char_upsteam_diverged '↕'
set -g __fish_git_prompt_char_upstream_equal '='
