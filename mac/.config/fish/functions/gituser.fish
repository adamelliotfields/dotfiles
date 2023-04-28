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
# To automatically sign commits you need this in your `~/.gitconfig`:
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
function gituser -d 'Switches the current Git user'
  argparse 'd/dry-run' 'e/email' 'h/help' 'k/key' 'x/xdg' -- $argv ; or return 1

  set -l dry_run $_flag_d
  set -l email $_flag_e
  set -l help $_flag_h
  set -l key $_flag_k
  set -l xdg $_flag_x

  set -l user $argv
  set -l help_msg "gituser

Updates your Git and GPG configs to use the given email address and associated key.
Requires the key to be in your keyring. Will clobber your existing GPG config if you have one.

USAGE:
  gituser [ARGS] [FLAGS]

ARGS:
  user           The email address of the user to sign commits

FLAGS:
  -d, --dry-run  Print the git config changes without making them
  -e, --email    Print the current email address
  -h, --help     Print this help message and exit
  -k, --key      Print the current signing key
  -x, --xdg      Use \$XDG_CONFIG_HOME/git/config instead of default git config handling"

  # exit early for help
  if test -n "$help"
    echo $help_msg
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
    test -n "$email" ; and echo $current_user
    test -n "$key" ; and echo $current_key_id
    return 0
  end

  # if no user was passed or the provided user is the same as the current user
  # print the current user and exit
  set -l result "[user]
  email = $current_user
  signingkey = $current_key_id"

  if test -z "$user" ; or test "$user" = "$current_user"
    echo $result
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

  # show a "diff" of the changes
  set -l diff "[user]
+  email = $user
-  email = $current_user
+  signingkey = $key_id
-  signingkey = $current_key_id"

  # print a color diff if bat is installed
  if command -v bat >/dev/null
    echo $diff | bat -pp -l diff --color=always
  else
    echo $diff
  end
end
