# abbreviations are like aliases except they are expanded on `space`
# using them to keep mac-only aliases separate from shared
# https://fishshell.com/docs/current/cmds/abbr.html
abbr -a -- refresh exec fish
abbr -a -- restart sudo shutdown -r now
abbr -a -- shutdown sudo shutdown -h now
abbr -a -- update 'brew update && brew upgrade && brew cleanup'
abbr -a -- mute "osascript -e 'set volume output muted true'"
abbr -a -- unmute "osascript -e 'set volume output muted false'"
abbr -a -- lock "osascript -e 'tell application \"System Events\" to keystroke \"q\" using {control down, command down}'"
abbr -a -- logout "osascript -e 'tell application \"System Events\" to log out'"
abbr -a -- finder "osascript -e 'tell application \"Finder\" to activate' -e 'tell application \"Finder\" to open home'"
abbr -a -- trash "osascript -e 'tell application \"Finder\" to empty trash'"

# interactively switch git user
abbr -a -- fzgu 'gituser (gituser --list | fzf)'
