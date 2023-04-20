# requires jorgebucaran/getopts
function ubuntu -d 'Run an Ubuntu container mounted to the current directory'
  # get the basename of the current directory
  set -l base_dir (basename $PWD)
  set -l shell 'bash'
  set -l port ''
  set -l _help "\
Usage:  ubuntu [OPTIONS]\n
Run an Ubuntu container mounted to the current directory 🐧\n
Options:
  -p, --port   The host port to bind to (default: none)
  -s, --shell  The shell to use (default: $shell)"

  # parse options
  if type -q getopts
    getopts $argv | while read -l key value
      switch $key
        case h help
          echo -e $_help
          return
        case p port
          set port $value
        case s shell
          set shell $value
      end
    end
  end

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
