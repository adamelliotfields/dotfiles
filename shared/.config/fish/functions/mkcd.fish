function mkcd -d 'Make a directory and `cd` into it'
  set -l dir $argv[1]

  # if no args make a temp dir
  if test -z $dir
    cd (mktemp -d /tmp/tmp.XXXX) # ex: /tmp/tmp.1234
    return 0
  end

  mkdir -p $dir
  cd $dir
end
