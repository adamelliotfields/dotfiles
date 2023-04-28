# https://github.com/jorgebucaran/humantime.fish (MIT)
function humantime --description 'Turn milliseconds into a human-readable string' --argument ms
  not set -q ms[1] ; and return 1

  # > 49ms = 0.1s
  set -l secs (math --scale=1 $ms/1000 % 60)
  set -l mins (math --scale=0 $ms/60000 % 60)
  set -l hours (math --scale=0 $ms/3600000)
  set -l out ''

  test $hours -gt 0 ; and set out $out$hours'h '
  test $mins -gt 0 ; and set out $out$mins'm '
  test $secs -gt 0 ; and set out $out$secs's'

  test -n "$out"
    and echo $out
    or echo $ms'ms'
end
