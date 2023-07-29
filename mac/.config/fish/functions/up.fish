function up -d 'Move up n-directories'
  argparse 'completions' -- $argv || return 1

  set -l n $argv[1]
  set -l path ''

  # completions
  # usage: up --completions | source
  set -q _flag_completions && begin
    echo 'complete -c up -f'
    echo "complete -c up -a \"(__complete_up)\""
    return 0
  end

  # check that n is a positive number
  # can also check if n is any number with `$n -eq $n`
  if test -n "$n" -a "$n" -gt 0 2>/dev/null
    for i in (seq $n)
      set path "$path../"
    end
  end

  test -n "$path"
    and cd $path
    or echo -e "up: $n is not a positive number\n\nUSAGE:\n  up <n>"
end


# https://fishshell.com/docs/current/completions.html
function __complete_up
  # count the number of slashes in the current directory
  set -l segments (echo $PWD | tr -cd '/' | wc -c)

  # e.g., if you're in /foo/bar/baz you can move up 2 times
  for i in (seq (math $segments - 1))
    test $i -gt 0 && echo $i
  end
end
