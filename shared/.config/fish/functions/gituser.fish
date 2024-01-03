function gituser -d 'Switches the current Git user'
  set -l completions_txt 'Print Fish completions'
  set -l dry_run_txt 'Print the git config changes without making them'
  set -l email_txt 'Print the current email address'
  set -l help_txt 'Print this help message and exit'
  set -l key_txt 'Print the current signing key'
  set -l list_txt 'List all of the email addresses in your keyring'
  set -l quiet_txt 'Suppress all output'
  set -l xdg_txt 'Use $XDG_CONFIG_HOME/git/config instead of default git config handling'

  set -l help_msg "gituser\n
Updates your Git and GPG configs to use the given email address and associated key.
Requires the key to be in your keyring. Will clobber your existing GPG config if you have one.\n
EXAMPLES:
  gituser email@example.com
  gituser (gituser -l | fzf)\n
USAGE:
  gituser [USER] [FLAGS]\n
USER:
  The email address to use for the Git user.\n
FLAGS:
      --completions    $completions_txt
  -d, --dry-run        $dry_run_txt
  -e, --email          $email_txt
  -h, --help           $help_txt
  -k, --key            $key_txt
  -l, --list           $list_txt
  -q, --quiet          $quiet_txt
  -x, --xdg            $xdg_txt"

  argparse 'completions' 'd/dry-run' 'e/email' 'h/help' 'k/key' 'l/list' 'q/quiet' 'x/xdg' -- $argv ; or return 1

  set -l completions $_flag_completions
  set -l dry_run $_flag_d
  set -l email $_flag_e
  set -l _help $_flag_h
  set -l key $_flag_k
  set -l list $_flag_l
  set -l quiet $_flag_q
  set -l xdg $_flag_x

  set -l user $argv

  # exit early for help
  # overrides all other flags
  if test -n "$_help"
    echo -e $help_msg
    return 0
  end

  # print completions
  # usage: gituser --completions | source
  if test -n "$completions"
    echo "\
complete -c gituser -f
complete -c gituser -a '(gituser --list)'
complete -c gituser -l completions -d '$completions_txt'
complete -c gituser -s d -l dry-run -d '$dry_run_txt'
complete -c gituser -s e -l email -d '$email_txt'
complete -c gituser -s h -l help -d '$help_txt'
complete -c gituser -s k -l key -d '$key_txt'
complete -c gituser -s l -l list -d '$list_txt'
complete -c gituser -s q -l quiet -d '$quiet_txt'
complete -c gituser -s x -l xdg -d '$xdg_txt'"
    return 0
  end

  # list email addresses
  if test -n "$list"
    test -z "$quiet" ; and gpg --list-keys | awk -F'[<>]' '/</ { print $2 }'
    return 0
  end

  # get the current user and signing key
  set -l current_user ''
  set -l current_key_id ''
  set -l xdg_config_home ''
  set -l xdg_git_config ''

  # force using the XDG config
  if test -n "$xdg"
    if test -z "$XDG_CONFIG_HOME"
      set xdg_config_home $HOME'/.config'
    else
      set xdg_config_home $XDG_CONFIG_HOME
    end

    set xdg_git_config $xdg_config_home'/git/config'

    if test -e "$xdg_git_config"
      set current_user (git config -f $xdg_git_config user.email 2>/dev/null)
      set current_key_id (git config -f $xdg_git_config user.signingkey 2>/dev/null)
    else
      mkdir -p $xdg_config_home'/git'
      touch $xdg_git_config
    end
  else
    # use default config resolution
    set current_user (git config --global user.email 2>/dev/null)
    set current_key_id (git config --global user.signingkey 2>/dev/null)
  end

  # print the current user or key and exit if one of the flags was passed
  if test -n "$email" ; or test -n "$key"
    test -z "$quiet" -a -n "$email" ; and echo $current_user
    test -z "$quiet" -a -n "$key" ; and echo $current_key_id
    return 0
  end

  # if no user was passed or the provided user is the same as the current user
  # print the current user and exit
  set -l result "[user]
  email = $current_user
  signingkey = $current_key_id"

  if test -z "$user" ; or test "$user" = "$current_user"
    test -z "$quiet" ; and echo $result
    return 0
  end

  # get all of the keys for the provided email address
  set -l gpg_keys (gpg --list-keys --with-colons $user)

  # gpg will print an error if the email isn't in the keyring
  if test $status -ne 0
    return 1
  end

  # get the public key id specifically
  # convert the spaces to newlines then find the line that starts with "pub"
  # the fields are separated by colons and the 5th field is the key id
  set -l key_id (echo $gpg_keys | tr ' ' '\n' | grep '^pub' | cut -d':' -f5)

  # update the git config
  if not test -n "$dry_run"
    if test -n "$xdg"
      git config -f $xdg_git_config user.email $user
      git config -f $xdg_git_config user.signingkey $key_id
    else
      git config --global user.email $user
      git config --global user.signingkey $key_id
    end

    # update the gpg config
    mkdir -p ~/.gnupg
    echo "default-key $key_id" | tee ~/.gnupg/gpg.conf >/dev/null
  end

  # print a color diff if bat is installed
  if test -z "$quiet"
    # show a "diff" of the changes
    set -l diff "[user]
+  email = $user
-  email = $current_user
+  signingkey = $key_id
-  signingkey = $current_key_id"

    if command -v bat >/dev/null
      echo $diff | bat -pp -l diff --color=always
    else
      echo $diff
    end
  end
end
