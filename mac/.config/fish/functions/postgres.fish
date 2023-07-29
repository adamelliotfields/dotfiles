# @example postgres -d mydb -U myuser -P mypassword
# @example postgres -t 9.6
function postgres -d 'Run a postgres container'
  argparse 't/tag=' 'n/name=' 'v/volume=' 'p/port=' 'd/db=' 'U/user=' 'P/password=' 'h/help' -- $argv || return 1

  set -l tag latest
  set -l name postgres
  set -l volume postgres
  set -l port 5432
  set -l postgres_db postgres
  set -l postgres_user postgres
  set -l postgres_password postgres

  set -q _flag_t && set tag $_flag_t
  set -q _flag_n && set name $_flag_n
  set -q _flag_v && set volume $_flag_v
  set -q _flag_p && set port $_flag_p
  set -q _flag_d && set postgres_db $_flag_d
  set -q _flag_U && set postgres_user $_flag_U
  set -q _flag_P && set postgres_password $_flag_P

  set -q _flag_h && begin
    echo 'Run a postgres container 🐘'
    echo
    echo (set_color -o)'USAGE'(set_color normal)
    echo '  postgres [flags]'
    echo
    echo (set_color -o)'FLAGS'(set_color normal)
    echo '  -t, --tag         The Docker image tag to use (default: latest)'
    echo '  -n, --name        The Docker container name to use (default: postgres)'
    echo '  -v, --volume      The Docker volume to use (default: postgres)'
    echo '  -p, --port        The host port to bind to (default: 5432)'
    echo '  -d, --db          Set the $POSTGRES_DB variable (default: postgres)'
    echo '  -U, --user        Set the $POSTGRES_USER variable (default: postgres)'
    echo '  -P, --password    Set the $POSTGRES_PASSWORD variable (default: postgres)'
    echo '  -h, --help        Show this message and exit'
    return 0
  end

  set -l opts \
    -d \
    -v $volume:/var/lib/postgresql/data \
    -e POSTGRES_DB=$postgres_db \
    -e POSTGRES_USER=$postgres_user \
    -e POSTGRES_PASSWORD=$postgres_password \
    -e POSTGRES_HOST_AUTH_METHOD=password \
    -p $port:5432 \
    --name $name

  # if the container already exists, Docker will simply print an error message and exit
  docker run $opts postgres:$tag
end
