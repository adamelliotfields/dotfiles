function file -d 'file.fish'
  set -l args 'e/expires=' 'h/help' 'o/out='
  argparse $args -- $argv ; or return $status

  # app name
  set -l app file

  # arguments
  set -l expires $_flag_e
  set -l out $_flag_o
  set -l src $argv[1]

  # curl args
  set -l url https://file.io
  set -l opts -s

  # help
  set -q _flag_h ; and begin
    echo $app'.fish: upload and download files from file.io'
    echo
    echo (set_color -o)'USAGE'(set_color normal)
    echo '  '$app' [FLAGS] [--] <ARGS>'
    echo
    echo (set_color -o)'FLAGS'(set_color normal)
    echo '  -e, --expires=TIME  set expiration time'
    echo '  -h, --help          show help'
    echo '  -o, --out=FILE      output to file'
    echo
    echo (set_color -o)'ARGS'(set_color normal)
    echo '  <FILE|URL>          file to upload; or file.io URL to download from'
    echo
    echo (set_color -o)'EXAMPLES'(set_color normal)
    echo '  '$app' file.txt'
    echo '  '$app' -e 1h file.txt'
    echo '  '$app' https://file.io/a3BQX1KbtobV'
    echo '  '$app' -o file.txt https://file.io/a3BQX1KbtobV'
    return 0
  end

  # if $src contains "file.io/" then set ID to it
  set -l id ''
  if string match -rq 'file.io/' $src
    set id $src
  end

  # if $id contains "file.io/" then get ID from it
  if string match -rq 'file.io/' $id
    set id (string split 'file.io/' $id)[2]
  end

  # if $id is zero-length then we are in upload mode
  if test -z "$id"
    # check if $src is set
    if test -z "$src"
      echo $app': no file specified'
      return 1
    end

    # check if file exists
    if not test -f "$src"
      echo $app': not found ("'$src'")'
      return 1
    end

    # set expiration
    if test -n "$expires"
      set url $url'?expires='$expires
    end

    # fire request
    set -a opts --fail-with-body -F "file=@$src"
    set -l res (curl $opts $url)

    # handle error
    if test $status -gt 0
      if test -n "$res"
        # {"success":false,"status":400,"key":"a3BQX1KbtobV","message": "Error..."}
        set -l message (echo $res | jq -r '.message')
        echo $app': '$message
      else
        echo $app': error uploading file "'$src'"'
      end
      return 1
    end
    # {"success":true,"status":200,"key":"a3BQX1KbtobV","link":"https://file.io/a3BQX1KbtobV"}
    echo $res | jq -rM '.link'
    return 0
  end

  # download mode
  set url $url'/'$id

  # output to id if out_file is not set
  # if you `--fail-with-body` when downloading a file, the error response will be written to the file
  if test -z "$out"
    set -a opts -f -O
  else
    set -a opts -f -o $out
  end

  # fire request
  set -l res (curl $opts $url)

  # handle error
  if test $status -gt 0
    if test -n "$res"
      set -l message (echo $res | jq -rM '.message')
      echo $app': '$message
    else
      echo $app': error downloading ID "'$id'"'
    end
    return 1
  end
end
