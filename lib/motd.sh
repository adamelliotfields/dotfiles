# message of the day with fastfetch
function dotfiles_motd {
  # run as sudo if not root
  function _sudo {
    [[ $EUID -ne 0 ]] && sudo "$@" || "$@"
  }

  # note that you wont get update reminders at login now
  _sudo mkdir -p /etc/update-motd.d
  _sudo rm -f /etc/update-motd.d/*

  # display logo and information with newline in between
  _sudo tee /etc/update-motd.d/99-fastfetch >/dev/null <<'EOF'
#!/bin/sh
fastfetch \
--pipe false \
--logo linux \
--structure Logo
printf '\n'
fastfetch \
--pipe false \
--logo none \
--color-keys yellow \
--structure-disabled Title:Separator:Host:Shell:Terminal:Display:Theme:Icons:Cursor:Swap:Locale:Break:Colors
EOF

  _sudo chmod +x /etc/update-motd.d/99-fastfetch
}
