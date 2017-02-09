# Config file
# =========================
# Sets application config parameters depending on `env` name
# * DEBUG_LOG: Activate logs level debug
# * DEBUG_WARN: Activate logs level warning
# * DEBUG_ERROR: Activate logs level error
# * DEBUG_CLIENT: Send debug error's info to client
# * MONGO_DB: MongoDb connection string
# * MEDIA_PATH: Path in URL where media files will be served.
# It must finish with slash /
# * MEDIA_ROOT: Absolute path in filesystem where media files will be stored.
# It must finish with slash /
# * EMAIL_HOST smtp server address
# * EMAIL_USER smtp user
# * EMAIL_PASSWORD smtp password
# * EMAIL_FROM 'from' field of generated emails

exports.setEnvironment = (env) ->
  console.log "set app environment: #{env}"
  switch(env)
    when "development"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      exports.MONGO_DB = 'mongodb://localhost/dentaljs-dev'
      exports.MEDIA_PATH = '/media/'
      exports.MEDIA_ROOT = process.cwd() + '/media/'
      exports.EMAIL_HOST = process.env.EMAIL_HOST or 'localhost'
      exports.EMAIL_USER = process.env.EMAIL_USER
      exports.EMAIL_PASSWORD = process.env.EMAIL_PASSWORD
      exports.EMAIL_FROM = process.env.EMAIL_FROM

    when "testing"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      exports.MONGO_DB = 'mongodb://localhost/test'
      exports.MEDIA_PATH = '/media/'
      exports.MEDIA_ROOT = '/tmp/dentaljs/media/'
      exports.EMAIL_HOST = process.env.EMAIL_HOST or 'localhost'
      exports.EMAIL_USER = process.env.EMAIL_USER
      exports.EMAIL_PASSWORD = process.env.EMAIL_PASSWORD
      exports.EMAIL_FROM = process.env.EMAIL_FROM

    when "production"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      exports.MONGO_DB = 'mongodb://db/dentaljs'
      exports.MEDIA_PATH = '/media/'
      exports.MEDIA_ROOT = '/media/'
      exports.EMAIL_HOST = process.env.EMAIL_HOST or 'localhost'
      exports.EMAIL_USER = process.env.EMAIL_USER
      exports.EMAIL_PASSWORD = process.env.EMAIL_PASSWORD
      exports.EMAIL_FROM = process.env.EMAIL_FROM
    else
      console.log "environment #{env} not found"
