// https://hyper.is#cfg
module.exports = {
  config: {
    updateChannel: "stable",
    fontSize: 24,
    fontFamily:
      "'MonoLisa Variable', 'Symbols Nerd Font', 'CaskaydiaCove Nerd Font', Menlo, 'DejaVu Sans Mono', monospace",
    fontWeight: "normal",
    fontWeightBold: "bold",
    lineHeight: 1,
    letterSpacing: 0,
    cursorShape: "BLOCK",
    cursorBlink: true,
    padding: "0px 16px",
    shell: "/usr/local/bin/fish",
    shellArgs: ["--login"],
    env: {},
    bell: false,
    copyOnSelect: false,
    defaultSSHApp: false,
    quickEdit: false,
    macOptionSelectionMode: "force",
    webGLRenderer: true,
    webLinksActivationKey: "meta",
    disableLigatures: false,
    disableAutoUpdates: false,
    screenReaderMode: false,
    preserveCWD: true,
    termCSS: "",
    css: "",
    // backgroundColor: "#0d1117", // https://github.com/sindresorhus/github-markdown-css/blob/main/github-markdown-dark.css
  },
  localPlugins: ["dracula-pro"], // ln -s ~/.dracula/themes/hyper/dracula-pro-van-helsing ~/.hyper_plugins/local/dracula-pro
  plugins: [],
  keymaps: {},
};
//# sourceMappingURL=config-default.js.map
