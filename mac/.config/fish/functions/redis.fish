# Redis Stack is a single Docker image that bundles modules like RedisInsight (web GUI), RedisJSON, etc
# RedisInsight will be available at http://localhost:8001
function redis -d 'Run a Redis Stack container'
  argparse 't/tag' 'n/name' 'v/volume' 'p/port' 'h/help' -- $argv || return $status

  set -l port 6379
  set -l tag latest
  set -l name redis
  set -l volume redis

  set -q _flag_t && set tag $_flag_t
  set -q _flag_n && set name $_flag_n
  set -q _flag_v && set volume $_flag_v
  set -q _flag_p && set port $_flag_p

  set -q _flag_h && begin
    echo -s 'Run a redis container with RedisInsight at http://localhost:8001  ⚡️'
    echo
    echo (set_color -o)'USAGE'(set_color normal)
    echo '  redis [flags]'
    echo
    echo (set_color -o)'FLAGS'(set_color normal)
    echo "  -t, --tag       The Docker image tag to use (default: $tag)"
    echo "  -n, --name      The Docker container name to use (default: $name)"
    echo "  -v, --volume    The Docker volume to use (default: $volume)"
    echo "  -p, --port      The host port to bind redis-server to (default: $port)"
    return 0
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
