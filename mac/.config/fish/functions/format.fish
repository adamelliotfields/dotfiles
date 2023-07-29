function format -d 'Format a number'
  argparse 'c/currency' 't/time' -- $argv || return 1
  set -l num $argv[1]

  # format as currency
  if test -n "$_flag_c"
    set num (math -s2 -- $num)
    set -l dec (string split -- '.' $num)[2]
    set -l int (string split -- '.' $num)[1]
    set -l int_len (string length -- $int)
    set -l out ''

    for i in (seq $int_len)
      set -l pos (math "$int_len - $i + 1")
      if test (math "($i - 1) % 3") -eq 0 && test $i -ne 1
        set out ','$out
      end
      set out (string sub -s $pos -l 1 -- $int)"$out"
    end

    # scale rounds and removes the trailing 0
    test -z "$dec" && set dec '00'
    test (string length $dec) -eq 1 && set dec $dec'0'
    echo $out'.'$dec
    return 0
  end

  # format as time
  # assume `num` is a number of milliseconds
  if test -n "$_flag_t"
    # > 49ms = 0.1s
    set -l secs (math -s1 $num / 1000 % 60) # there are 1000 milliseconds in a second
    set -l mins (math -s0 $num / 60000 % 60) # there are 60000 milliseconds in a minute
    set -l hours (math -s0 $num / 3600000 % 24) # there are 3600000 milliseconds in an hour
    set -l days (math -s0 $num / 86400000 % 7) # there are 86400000 milliseconds in a day
    set -l weeks (math -s0 $num / 604800000 % 52) # there are 604800000 milliseconds in a week
    set -l years (math -s0 $num / 31536000000) # there are 31536000000 milliseconds in a year
    set -l out ''

    test $years -gt 0 && set out $out$years'y '
    test $weeks -gt 0 && set out $out$weeks'w '
    test $days -gt 0 && set out $out$days'd '
    test $hours -gt 0 && set out $out$hours'h '
    test $mins -gt 0 && set out $out$mins'm '
    test $secs -gt 0 && set out $out$secs's'

    test -n "$out" && echo $out || echo $num'ms'

    return 0
  end

  # by default format as a number
  set -l units 'K' 'M' 'B' 'T'
  set -l unit_count 0

  while test $num -ge 1000
    set num (math --scale=2 $num / 1000)
    set unit_count (math $unit_count + 1)
  end

  if test $unit_count -gt (count $units)
    # use scientific notation for anything bigger
    printf "%0.2e\n" $num
  else
    # fish arrays are 1-indexed
    set -l unit $units[$unit_count]
    echo $num$unit
  end
end
