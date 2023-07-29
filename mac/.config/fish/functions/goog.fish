function goog -d 'Open Google pages from the terminal.'
  set -l args 'e/earth' 'f/flights' 'h/help' 'i/image' 'm/maps' 't/translate' 'r/trends' 'teapot' 'y/youtube'

  argparse $args -- $argv || return $status

  set -l query (string escape --style=url "$argv")

  # help
  set -q _flag_h && begin
    echo 'Open Google pages from the terminal.'
    echo
    echo (set_color -o)'USAGE'(set_color normal)
    echo '  goog [flags] [--] [query]'
    echo
    echo (set_color -o)'FLAGS'(set_color normal)
    echo '  -h, --help         Show this help message'
    echo '  -e, --earth        Open Google Earth'
    echo '  -f, --flights      Open Google Flights'
    echo '  -i, --image        Open Google Images'
    echo '  -m, --maps         Open Google Maps'
    echo '  -t, --translate    Open Google Translate'
    echo '  -r, --trends       Open Google Trends'
    echo '  -y, --youtube      Open YouTube'
    echo
    echo (set_color -o)'EXAMPLES'(set_color normal)
    echo '  $ goog calculator'
    echo '  $ goog color picker'
    echo '  $ goog tic tac toe'
    echo '  $ goog do a barrel roll'
    echo '  $ goog google doodle'
    echo '  $ goog "i\'m feeling curious"'
    return 0
  end

  # check for open
  if not command -q open
    echo 'goog: open is required'
    return 1
  end

  # google earth
  set -q _flag_e && begin
    if test -z "$query"
      open 'https://earth.google.com/web'
    else
      open 'https://earth.google.com/web/search/'$query
    end

    return 0
  end

  # google flights
  set -q _flag_f && begin
    if test -z "$query"
      open 'https://www.google.com/travel/flights'
    else
      open 'https://www.google.com/travel/flights?q='$query
    end

    return 0
  end

  # google images
  set -q _flag_i && begin
    if test -z "$query"
      open 'https://www.google.com/imghp'
    else
      open 'https://www.google.com/search?tbm=isch&q='$query
    end

    return 0
  end

  # google maps
  set -q _flag_m && begin
    if test -z "$query"
      open 'https://www.google.com/maps'
    else
      open 'https://www.google.com/maps/search/'$query
    end

    return 0
  end

  # google translate
  # source language is auto-detected, target language is english
  set -q _flag_t && begin
    if test -z "$query"
      open 'https://translate.google.com'
    else
      open 'https://translate.google.com/?sl=auto&tl=en&text='$query
    end

    return 0
  end

  # google trends
  # prefer US region to see state-by-state
  set -q _flag_r && begin
    if test -z "$query"
      open 'https://trends.google.com/trends'
    else
      open 'https://trends.google.com/trends/explore?geo=US&q='$query # region must be capitalized
    end

    return 0
  end

  # youtube
  set -q _flag_y && begin
    if test -z "$query"
      open 'https://www.youtube.com'
    else
      open 'https://www.youtube.com/results?search_query='$query
    end

    return 0
  end

  # teapot easter egg
  set -q _flag_teapot && begin
    open 'https://www.google.com/teapot'
    return 0
  end

  # google
  if test -n "$query"
    open 'https://www.google.com/search?q='$query
    return 0
  end

  open 'https://www.google.com'
end
