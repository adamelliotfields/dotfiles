# requires jorgebucaran/getopts
# @example postgres -d mydb -U myuser -P mypassword
# @example postgres -t 9.6
function postgres -d 'Run a postgres container'
  set -l tag 'latest'
  set -l name 'postgres'
  set -l volume 'postgres'
  set -l port 5432
  set -l postgres_db 'postgres'
  set -l postgres_user 'postgres'
  set -l postgres_password 'postgres'
  set -l _help "\
Usage:  postgres [OPTIONS]\n
Run a postgres container 🐘\n
Options:
  -t, --tag       The Docker image tag to use (default: latest)
  -n, --name      The Docker container name to use (default: postgres)
  -v, --volume    The Docker volume to use (default: postgres)
  -p, --port      The host port to bind to (default: 5432)
  -d, --db        Set the \$POSTGRES_DB variable (default: postgres)
  -U, --user      Set the \$POSTGRES_USER variable (default: postgres)
  -P, --password  Set the \$POSTGRES_PASSWORD variable (default: postgres)"

  # parse options
  if type -q getopts
    getopts $argv | while read -l key value
      switch $key
        case h help
          echo -e $_help
          return
        case t tag
          set tag $value
        case n name
          set name $value
        case v volume
          set volume $value
        case p port
          set port $value
        case d dbname
          set postgres_db $value
        case U username
          set postgres_user $value
        case P password
          set postgres_password $value
      end
    end
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
