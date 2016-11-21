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

exports.setEnvironment = (env) ->
  console.log "set app environment: #{env}"
  switch(env)
    when "development"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      exports.MONGO_DB = 'mongodb://172.19.0.2/dentaljs-dev'
      exports.MEDIA_PATH = '/media/'
      exports.MEDIA_ROOT = process.cwd() + '/media/'

    when "testing"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      exports.MONGO_DB = 'mongodb://172.19.0.2/test'
      exports.MEDIA_PATH = '/media/'
      exports.MEDIA_ROOT = '/tmp/dentaljs/media/'

    when "production"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      exports.MONGO_DB = 'mongodb://db/dentaljs'
      exports.MEDIA_PATH = '/media/'
      exports.MEDIA_ROOT = '/media/'
    else
      console.log "environment #{env} not found"
