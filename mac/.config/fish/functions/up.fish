function up -d 'Move up n-directories'
  set -l n $argv[1]
  set -l path ''

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
