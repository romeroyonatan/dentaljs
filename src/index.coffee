express = require('express')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
mongoose = require('mongoose')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
routes = require('./routes/index')

app = express()

# Define Port & Environment
app.port = process.env.PORT or process.env.VMC_APP_PORT or 3000
env = process.env.NODE_ENV or "development"

# Config module exports has `setEnvironment` function that sets app settings
# depending on environment.
config = require "./config"
config.setEnvironment env

# db_config
if env != 'production'
  mongoose.connect 'mongodb://localhost/example'
else
  console.log('If you are running in production, you may want to modify the
               mongoose connect path')

# view engine setup
#app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

#app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()
app.use express.static(process.cwd() + '/public')
app.use(require("connect-assets")())
app.use '/', routes

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next err
  return

# error handlers
# development error handler
# will print stacktrace
if app.get('env') == 'development'
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render 'error',
      message: err.message
      error: err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render 'error',
    message: err.message
    error: {}

module.exports = app
