// https://github.com/alacritty/alacritty-theme/blob/master/themes/github_light_default.yaml
const backgroundColor = '#ffffff'
const foregroundColor = '#0e1116'
const selectionColor = 'rgb(130, 80, 223, 0.3)'  // magenta
const black = '#24292f'
const red = '#cf222e'
const green = '#116329'
const yellow = '#4d2d00'
const blue = '#0969da'
const magenta = '#8250df'
const cyan = '#1b7c83'
const white = '#6e7781'
const lightBlack = '#57606a'
const lightRed = '#a40e26'
const lightGreen = '#1a7f37'
const lightYellow = '#633c01'
const lightBlue = '#218bff'
const lightMagenta = '#a475f9'
const lightCyan = '#3192aa'
const lightWhite = '#8c959f'

exports.decorateConfig = (config) => {
  return Object.assign({}, config, {
    backgroundColor,
    foregroundColor,
    selectionColor,
    borderColor: backgroundColor,
    cursorColor: magenta,
    cursorAccentColor: backgroundColor,
    colors: {
      black,
      red,
      green,
      yellow,
      blue,
      magenta,
      cyan,
      white,
      lightBlack,
      lightRed,
      lightGreen,
      lightYellow,
      lightBlue,
      lightMagenta,
      lightCyan,
      lightWhite
    },
    css: `
      ${config.css || ''}
      .hyper_main {
        border-color: ${backgroundColor} !important;
      }
      .tabs_list .tab_tab.tab_active .tab_text {
        background: ${backgroundColor};
      }
    `
  })
}
