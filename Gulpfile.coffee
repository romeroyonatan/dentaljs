gulp = require 'gulp'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'
karma = require 'karma'
jasmine = require 'gulp-jasmine'
jade = require 'gulp-jade'
gls = require 'gulp-live-server'
print = require 'gulp-print'
docco = require "gulp-docco"
{protractor, webdriver_update} = require 'gulp-protractor'
{exec, execSync, spawn} = require 'child_process'
path = require 'path'
fs = require 'fs'

# Build server's source code
gulp.task 'build-src', ->
  gulp.src 'src/**/*.coffee'
    .pipe coffee(bare: true).on 'error', gutil.log
    .pipe gulp.dest '.app/'

# Build jade templates
gulp.task 'build-jade', ->
  gulp.src ['assets/js/**/*.jade', '!assets/js/mixins', '!assets/js/layouts']
    .pipe jade()
    .pipe gulp.dest 'public/partials'

# Build test's source code
gulp.task 'build-spec', ['build'], ->
  gulp.src 'spec/**/*.coffee'
    .pipe coffee().on 'error', gutil.log
    .pipe gulp.dest '.spec/'

gulp.task 'build-e2e', ['build'], ->
  gulp.src 'e2e-tests/**/*.coffee'
    .pipe coffee().on 'error', gutil.log
    .pipe gulp.dest '.e2e-tests/'

# Run client-side tests
gulp.task 'test-client', (done)->
  server = new karma.Server
    configFile: __dirname + '/karma.conf.js',
    singleRun: true
  , done
  server.start()

# Run server-side tests
gulp.task 'test-server', ['build-spec'], ->
  gulp.src('.spec/**/*[sS]pec.js')
    .pipe jasmine
      verbose: on
      includeStackTrace: on
      config:
        spec_dir: '.spec'
        helpers: [
          'helpers/*helper.js'
        ]

# get the binary of protractor
getProtractorBinary = (binaryName) ->
  winExt = if /^win/.test(process.platform) then '.cmd' else ''
  pkgPath = require.resolve('protractor')
  protractorDir = path.resolve(path.join(path.dirname(pkgPath), '..', 'bin'))
  path.join(protractorDir, '/' + binaryName + winExt)

# update webdriver
gulp.task 'protractor-install', (done) ->
  spawn(getProtractorBinary('webdriver-manager'), ['update'], {
    stdio: 'inherit'
  }).once('close', done)

# run end-to-end tests
gulp.task 'protractor-run', ['protractor-install'], (done) ->
  argv = ['e2e-tests/protractor.conf.js']
  spawn(getProtractorBinary('protractor'), argv, {
    stdio: 'inherit'
  }).once('close', done)

gulp.task 'test-e2e', ['build-e2e', 'protractor-run']

# Build application's code
gulp.task 'build', ['build-src', 'build-jade'], ->

# Run all tests
gulp.task 'test', ['test-server', 'test-client'], ->

# Run development server
server = gls.new 'bin/www'
gulp.task 'run-server', ->
  server.start()

gulp.task 'stop-server', ->
  server.stop()

# Reload development server
gulp.task 'reload', ->
  server.start.bind(server)()

# Watch for changes in source code
gulp.task 'watch', ->
  gulp.watch 'src/**/*.coffee', ['build-src', ['reload']]
  gulp.watch 'assets/js/**/*.jade', ['build-jade']

# Generate docs
gulp.task 'docs', ->
  gulp.src 'src/**/*.coffee'
    .pipe docco()
    .pipe gulp.dest 'docs/server'
  gulp.src 'assets/js/**/*.coffee'
    .pipe docco()
    .pipe gulp.dest 'docs/client'

# Deploy application into docker container
gulp.task 'deploy', ['build'], ->
  #execSync 'git pull'
  execSync 'npm install --production'
  execSync 'bower install --production'
  version = execSync 'git describe --tags'
  execSync 'docker-compose build', env: DENTALJS_VERSION: version
  execSync 'docker-compose up -d'

# Backup application's data from mongo docker container
gulp.task 'backup', ->
  exec 'docker inspect --format
  "{{ .NetworkSettings.Networks.dentaljs_default.IPAddress }}" dentaljs_db_1',
  (error, stdout, stderr) ->
    ip = stdout
    console.log "Mongo server ip - " + ip
    if ip
      today = new Date
      path = "backup/" + today.toISOString()
      console.log "Creating backup folder " + path
      fs.mkdir path, ->
        execSync "mongodump -o #{path} -h #{ip}"
        console.log("Backup successful")

# Default task run a development server
gulp.task 'default', ['build', 'run-server', 'watch']
