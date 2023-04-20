function nvm -d 'nvm'
  # replay captures the changes nvm makes to the environment in Bash and _replays_ them in Fish
  # nvm will put the path to the current node version at the front of your $PATH
  # run `nvm unload` to remove it
  replay "source $HOME/.bashrc ; nvm" $argv
end
