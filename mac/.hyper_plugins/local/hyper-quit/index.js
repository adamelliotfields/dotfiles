// https://github.com/cblecker/hyper-quit (Apache 2.0)
const { app } = require('electron')

exports.onWindow = (w) => {
  w.on('closed', () => {
    const { size } = app.getWindows()
    if (size === 0) app.quit()
  })
}
