// https://hyper.is#cfg
module.exports = {
  config: {
    fontSize: 24,
    fontFamily: '"MonoLisa Variable", "Symbols Nerd Font", "CaskaydiaCove Nerd Font", Menlo, monospace',
    fontWeight: 'normal',
    fontWeightBold: 'bold',
    lineHeight: 1,
    cursorShape: 'BEAM',
    cursorBlink: true,
    padding: '0px 16px',
    shell: '/usr/local/bin/fish',
    shellArgs: [],
    bell: false,
    macOptionSelectionMode: 'force',
    webGLRenderer: true,
    webLinksActivationKey: 'meta',
    disableLigatures: false
  },
  localPlugins: [
    // ln -s ~/.dracula/themes/hyper/dracula-pro/index.js ~/.hyper_plugins/local/dracula-pro/index.js
    // 'dracula-pro',
    'github-theme',
    'hyper-quit'
  ]
}
//# sourceMappingURL=config-default.js.map
