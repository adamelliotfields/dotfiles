function ubuntu -d 'Run an Ubuntu container mounted to the current directory'
  argparse 'h/help' 'p/port=' 's/shell=' -- $argv || return 1

  # get the basename of the current directory
  set -l base_dir (basename $PWD)
  set -l shell 'bash'
  set -l port ''

  set -q _flag_p && set port $_flag_p
  set -q _flag_s && set shell $_flag_s

  set -q _flag_h && begin
    echo 'Run an Ubuntu container mounted to the current directory  🐧'
    echo
    echo (set_color -o)'USAGE'(set_color normal)
    echo '  ubuntu [flags]'
    echo
    echo (set_color -o)'FLAGS'(set_color normal)
    echo '  -p, --port   The host port to bind to (default: none)'
    echo "  -s, --shell  The shell to use (default: '$shell')"
    echo '  -h, --help   Show this message and exit'
    return 0
  end

  # docker run options
  set -l opts \
    -it \
    --rm \
    -u vscode \
    -w /$base_dir \
    -v $PWD:/$base_dir

  # set port if it exists
  test -n $port && set -a opts \
    -p $port:$port

  # set GH_TOKEN if it exists
  set -q GH_TOKEN && set -a opts \
    -e GH_TOKEN=$GH_TOKEN

  # if the container already exists, Docker will simply print an error message and exit
  docker run $opts mcr.microsoft.com/devcontainers/base:jammy $shell
end
