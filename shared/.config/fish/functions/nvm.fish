function nvm -d 'nvm'
  # replay captures the changes nvm makes to the environment in Bash and _replays_ them in Fish
  # nvm will put the path to the current node version at the front of your $PATH
  # run `nvm unload` to remove it

  set -l nvm_dir ''
  test -n "$NVM_DIR"
    and set nvm_dir $NVM_DIR
    or set nvm_dir $HOME'/.nvm'

  if test -s $nvm_dir'/nvm.sh'
    replay "set -e ; source $nvm_dir/nvm.sh --no-use ; nvm $argv"
    return $status
  end

  echo "$nvm_dir/nvm.sh: No such file or directory"
  return 1
end
