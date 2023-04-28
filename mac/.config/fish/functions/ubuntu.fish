function ubuntu -d 'Run an Ubuntu container mounted to the current directory'
  argparse 'h/help' 'p/port=' 's/shell=' -- $argv ; or return 1

  # get the basename of the current directory
  set -l base_dir (basename $PWD)
  set -l shell 'bash'
  set -l port ''
  set -l help_msg "\
Usage:  ubuntu [OPTIONS]\n
Run an Ubuntu container mounted to the current directory 🐧\n
Options:
  -p, --port   The host port to bind to (default: none)
  -s, --shell  The shell to use (default: $shell)
  -h, --help   Show this message and exit"

  set -q _flag_p ; and set port $_flag_p
  set -q _flag_s ; and set shell $_flag_s
  set -q _flag_h ; and echo -e $help_msg ; and return 0

  # docker run options
  set -l opts \
    -it \
    --rm \
    -u vscode \
    -w /$base_dir \
    -v $PWD:/$base_dir

  # set port if it exists
  test -n $port ; and set -a opts \
    -p $port:$port

  # set GH_TOKEN if it exists
  set -q GH_TOKEN ; and set -a opts \
    -e GH_TOKEN=$GH_TOKEN

  # if the container already exists, Docker will simply print an error message and exit
  docker run $opts mcr.microsoft.com/devcontainers/base:ubuntu $shell
end
