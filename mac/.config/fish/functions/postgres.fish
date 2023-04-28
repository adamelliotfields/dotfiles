# @example postgres -d mydb -U myuser -P mypassword
# @example postgres -t 9.6
function postgres -d 'Run a postgres container'
  argparse 't/tag=' 'n/name=' 'v/volume=' 'p/port=' 'd/db=' 'U/user=' 'P/password=' 'h/help' -- $argv ; or return 1

  set -l tag latest
  set -l name postgres
  set -l volume postgres
  set -l port 5432
  set -l postgres_db postgres
  set -l postgres_user postgres
  set -l postgres_password postgres

  set -q _flag_t ; and set tag $_flag_t
  set -q _flag_n ; and set name $_flag_n
  set -q _flag_v ; and set volume $_flag_v
  set -q _flag_p ; and set port $_flag_p
  set -q _flag_d ; and set postgres_db $_flag_d
  set -q _flag_U ; and set postgres_user $_flag_U
  set -q _flag_P ; and set postgres_password $_flag_P

  set -l help_msg "\
Usage:  postgres [OPTIONS]\n
Run a postgres container 🐘\n
Options:
  -t, --tag       The Docker image tag to use (default: latest)
  -n, --name      The Docker container name to use (default: postgres)
  -v, --volume    The Docker volume to use (default: postgres)
  -p, --port      The host port to bind to (default: 5432)
  -d, --db        Set the \$POSTGRES_DB variable (default: postgres)
  -U, --user      Set the \$POSTGRES_USER variable (default: postgres)
  -P, --password  Set the \$POSTGRES_PASSWORD variable (default: postgres)
  -h, --help      Show this message and exit"

  set -q _flag_h ; and begin
    echo -e $help_msg
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
