function __complete_vault
  set -lx COMP_LINE (commandline -cp)
  test -z (commandline -ct) ; and set COMP_LINE $COMP_LINE' '
  vault
end

complete -c vault -f
complete -c vault -a "(__complete_vault)"
