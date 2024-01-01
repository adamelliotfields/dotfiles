# usage:
#   fish -c 'spinner' &
#   set pid $last_pid
#   sleep 2
#   kill $pid
#   echo -ne '\r'
function spinner -d 'A simple loading spinner for Fish'
  argparse 'm/moon' 'c/cloud' -- $argv 2>/dev/null

  set -l moon $_flag_m
  set -l cloud $_flag_c

  set -l cr '\r'
  set -l spaces ' '
  set -l chars ''
  set -l plain_chars '|' '/' '-' '\\'

  # these are full-width characters so they only require 1 space for alignment
  set -l moon_chars '\U1F311' # 🌑 new moon
  set -a moon_chars '\U1F312' # 🌒 waxing crescent moon
  set -a moon_chars '\U1F313' # 🌓 first quarter moon
  set -a moon_chars '\U1F314' # 🌔 waxing gibbous moon
  set -a moon_chars '\U1F315' # 🌕 full moon
  set -a moon_chars '\U1F316' # 🌖 waning gibbous moon
  set -a moon_chars '\U1F317' # 🌗 last quarter moon
  set -a moon_chars '\U1F318' # 🌘 waning crescent moon

  # these are half-width characters so they require 2 spaces for alignment
  # note you can run into issues with these
  set -l cloud_chars '\U1F324\UFE0F' # 🌤️ sun behind small cloud
  set -a cloud_chars '\U1F326\UFE0F' # 🌦️ sun behind rain cloud
  set -a cloud_chars '\U1F327\UFE0F' # 🌧️ cloud with rain
  set -a cloud_chars '\U26C8\UFE0F'  # ⛈️ cloud with lightning and rain
  set -a cloud_chars '\U1F329\UFE0F' # 🌩️ cloud with lightning
  set -a cloud_chars '\U1F325\UFE0F' # 🌥️ sun behind large cloud

  if test -n "$cloud"
    set chars $cloud_chars
    set spaces '  '
  else if test -n "$moon"
    set chars $moon_chars
  else
    set chars $plain_chars
  end

  # I cannot get something like `trap 'echo -ne "\r"' EXIT INT` to work
  # so you just have to clear it manually with `echo -ne '\r'`
  set -l i 1
  while true
    printf '%b%b%s' $cr $chars[$i] $spaces
    set i (math $i % (count $chars) + 1)
    sleep 0.2
  end
end
