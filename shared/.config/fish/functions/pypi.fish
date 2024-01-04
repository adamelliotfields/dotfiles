function pypi -d 'pypi.fish'
  set -l args \
    'd/description' \
    'h/help' \
    'u/urls' \
    'v/version'
  argparse $args -- $argv ; or return $status

  # app name
  set -l app pypi

  # arguments
  set -l package (string lower $argv[1])

  # help
  if set -q _flag_h
    echo $app'.fish: Search pypi.org for package info'
    echo
    echo (set_color -o)'USAGE'(set_color normal)
    echo '  '$app' [flags] [--] <args>'
    echo
    echo (set_color -o)'ARGS'(set_color normal)
    echo '  package            Package to search for'
    echo
    echo (set_color -o)'FLAGS'(set_color normal)
    echo '  -d, --description  Show package description'
    echo '  -u, --urls         Show package URLs'
    echo '  -v, --version      Show package version'
    echo '  -h, --help         Print this message and exit'
    return 0
  end

  # no package
  if test -z $package
    echo $app': No package specified'
    return 1
  end

  # get response
  set response (curl -fsL 'https://pypi.org/pypi/'$package'/json') ; or begin
    echo $app': Error fetching package "'$package'"'
    return 1
  end

  # description flag
  if set -q _flag_d
    echo $response | jq -rM '.info.description' | bat -pl markdown
    return 0
  end

  # urls flag
  if set -q _flag_u
    set -l project_urls_keys
    set -l project_urls_values
    set -l i 1

    for key in (echo $response | jq -rM '.info.project_urls | keys[]')
      set project_urls_keys $project_urls_keys $key
    end

    for value in (echo $response | jq -rM '.info.project_urls | .[]')
      set project_urls_values $project_urls_values $value
    end

    for key in $project_urls_keys
      echo (set_color -o)$key(set_color normal)': '$project_urls_values[$i]
      set i (math $i + 1)
    end
    return 0
  end

  # version flag
  if set -q _flag_v
    echo $response | jq -rM '.info.version'
    return 0
  end

  # no flags
  set -l ver (echo $response | jq -rM '.info.version')
  set -l summary (echo $response | jq -rM '.info.summary')
  set -l url 'https://pypi.org/project/'$package

  echo (set_color -o)$package(set_color normal)' v'$ver
  echo $summary
  echo (set_color -u)$url(set_color normal)
  return 0
end
