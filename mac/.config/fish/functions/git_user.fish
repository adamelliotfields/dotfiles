# Need `gpg` and optionally `bat`:
#   - Linux: `apt install gnpupg dirmngr bat`
#   - macOS: `brew install gnupg bat`
#
# Your *secret* key must be in your GPG keyring.
# ```sh
# keybase pgp list # view your key ids
# key_id=<your_key_id>
# keybase pgp export --secret --unencrypted -q $key_id | gpg --import
#
# ```
# You have to trust the key with `gpg --edit-key $key_id` and then `5 (trust ultimately)` and `quit`.
# To sign commits you need this in your `~/.gitconfig` or `~/.config/git/config`:
# ```
# [commit]
#   gpgsign = true
# [gpg]
#   program = /usr/local/bin/gpg # or wherever gpg is installed
# ```
#
# Finally, your *public* key must be in your GitHub account.
# ```sh
# keybase pgp export --unencrypted -q $key_id | tee /tmp/pub.asc >/dev/null
# gh gpg-key add /tmp/pub.asc # requires gpg scope on your GH_TOKEN
# ```
function git_user --description 'Switches the current Git user'
  set -l email ''
  set -l xdg 'false'
  set -l help 'false'
  set -l dry_run 'false'
  set -l usage_msg "USAGE:
  git_user <ARGS> [FLAGS]"
  set -l help_msg "git_user

Updates your git and gpg configs to use the given email address.
Requires the key associated with the email address to be in your GPG keyring.

$usage_msg

ARGS:
  email        The email address to use for git commits (required)

FLAGS:
  -d, --dry-run  Print the git config changes without making them
  -h, --help     Print this help message and exit
  -x, --xdg      Use \$XDG_CONFIG_HOME/git/config instead of default git config handling"

  # parse the command line arguments
  while test (count $argv) -gt 0
    switch $argv[1]
      case -d --dry-run
        set dry_run 'true'
        set -e argv[1] # https://stackoverflow.com/a/24101186/3586996
      case -h --help
        set help 'true'
        set -e argv[1]
      case -x --xdg
        set xdg 'true'
        set -e argv[1]
      case '*'
        set email $argv[1]
        set -e argv[1]
    end
  end

  if test $help = 'true'
    echo "$help_msg"
    return 0
  end

  if test -z $email
    echo "$usage_msg"
    return 1
  end

  # get the current user and signing key
  set -l current_email ''
  set -l current_key_id ''
  set -l xdg_config_home ''
  set -l xdg_git_config ''

  if test $xdg = 'true'
    if test -z $XDG_CONFIG_HOME
      set xdg_config_home $HOME/.config
    else
      set xdg_config_home $XDG_CONFIG_HOME
    end

    set xdg_git_config $xdg_config_home/git/config

    if test -e $xdg_git_config
      set current_email (git config -f $git_config_path user.email 2>/dev/null)
      set current_key_id (git config -f $git_config_path user.signingkey 2>/dev/null)
    else
      mkdir -p $xdg_config_home/git
      touch $xdg_git_config
    end
  end

  test -z $current_email ; and set current_email (git config --global user.email 2>/dev/null)
  test -z $current_key_id ; and set current_key_id (git config --global user.signingkey 2>/dev/null)

  # desired user is already set
  # print their configuration
  set -l result "[user]
  email = $current_email
  signingkey = $current_key_id"
  if test $email = $current_email
    echo $result
    return 0
  end

  # get the user's keys
  set -l gpg_keys (gpg --list-keys --with-colons $email)

  # gpg will print an error if the email isn't in the keyring
  if test $status -ne 0
    return 1
  end

  # get the key id
  # convert the spaces to newlines then find the line that starts with "pub"
  # the fields are separated by colons and the 5th field is the key id
  set -l key_id (echo $gpg_keys | tr ' ' '\n' | grep '^pub' | cut -d':' -f5)

  if test $dry_run != 'true'
    if test $xdg = 'true'
      git config -f $git_config_path user.email $email
      git config -f $git_config_path user.signingkey $key_id
    else
      git config --global user.email $email
      git config --global user.signingkey $key_id
    end

    # update the gpg config
    mkdir -p ~/.gnupg
    echo "default-key $key_id" | tee ~/.gnupg/gpg.conf >/dev/null
  end

  # show a "diff" of the changes
  set -l diff "[user]
+  email = $email
-  email = $current_email
+  signingkey = $key_id
-  signingkey = $current_key_id"

  # print a color diff if bat is installed
  if command -v bat >/dev/null
    echo $diff | bat -pp -l diff --color=always
  else
    cat $diff
  end
end
