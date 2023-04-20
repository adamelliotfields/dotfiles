# Redis Stack is a single Docker image that bundles modules like RedisInsight (web GUI), RedisJSON, etc
# RedisInsight will be available at http://localhost:8001
# requires jorgebucaran/getopts
function redis -d 'Run a Redis Stack container'
  set -l port 6379
  set -l tag 'latest'
  set -l name 'redis'
  set -l volume 'redis'
  set -l _help "\
Usage:  redis [OPTIONS]\n
Run a redis container with RedisInsight at http://localhost:8001 ⚡️\n
Options:
  -t, --tag       The Docker image tag to use (default: $tag)
  -n, --name      The Docker container name to use (default: $name)
  -v, --volume    The Docker volume to use (default: $volume)
  -p, --port      The host port to bind redis-server to (default: $port)"

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
      end
    end
  end

  set -l opts \
    -d \
    -v $volume:/data \
    -p $port:6379 \
    -p 8001:8001 \
    --name $name

  # if the container already exists, Docker will simply print an error message and exit
  docker run $opts redis/redis-stack:$tag
end
