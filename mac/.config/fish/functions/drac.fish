function drac -d 'Dracula'
  set -l args \
    'h/help' \
    'u/uninstall'
  argparse $args -- $argv ; or return $status

  if set -q _flag_h
    echo 'Dracula Pro theme switcher for Hyper terminal'
    echo
    echo (set_color -o)'USAGE'(set_color normal)
    echo '  drac [flags] [--] <theme>'
    echo
    echo (set_color -o)'THEME'(set_color normal)
    echo '  A Dracula Pro theme:'
    echo '    * pro'
    echo '    * blade'
    echo '    * buffy'
    echo '    * lincoln'
    echo '    * morbius'
    echo '    * van-helsing'
    echo '    * alucard'
    echo
    echo (set_color -o)'FLAGS'(set_color normal)
    echo '  -h, --help       Print this message and exit'
    echo '  -u, --uninstall  Remove the installed theme'
    echo
    echo (set_color -o)'INSTALL'(set_color normal)
    echo '  1. Download from https://gum.co/dracula-pro'
    echo '  2. Unzip to ~/.dracula'
    echo '  3. Append `"dracula-pro"` to `localPlugins` in ~/.hyper.js'
    return 0
  end

  set -l src_path $HOME'/.dracula/themes/hyper'
  set -l dest_path $HOME'/.hyper_plugins/local/dracula-pro'

  set -l theme (string lower $argv[1])
  set -l theme_long ''
  set -l themes \
    'pro' \
    'blade' \
    'buffy' \
    'lincoln' \
    'morbius' \
    'van-helsing' \
    'alucard'

  if set -q _flag_u
    rm -rf $dest_path
    mkdir -p $dest_path
    echo 'exports.decorateConfig = (config) => config;' | tee $dest_path'/index.js' > /dev/null
    echo '✅ Uninstalled theme'
    echo '🎨 Restart Hyper to apply'
    return 0
  end

  if test -z $theme
    echo 'drac: no theme specified'
    return 1
  end

  if not contains $theme $themes
    echo 'drac: unknown theme "'$theme'"'
    return 1
  end

  if test $theme = 'pro'
    set theme_long 'dracula-pro'
  else
    set theme_long 'dracula-pro-'$theme
  end

  # check if ~/.dracula/themes/hyper/$theme exists
  if not test -e $src_path'/'$theme_long
    echo 'drac: theme "'$theme'" not downloaded'
    return 1
  end

  # just name the plugin "dracula-pro" in Hyper so you never have to touch the config
  rm -rf $dest_path
  mkdir -p $dest_path
  ln -s $src_path'/'$theme_long'/index.js' $dest_path'/index.js'

  # reload/full-reload doesn't work
  echo '✅ Installed "'$theme'" theme'
  echo '🎨 Restart Hyper to apply'
  return 0
end
