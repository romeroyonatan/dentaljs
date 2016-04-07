gulp = require 'gulp'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'
karma = require 'karma'
jasmine = require 'gulp-jasmine'
jade = require 'gulp-jade'
server = require 'gulp-express'
print = require 'gulp-print'
docco = require "gulp-docco"
{protractor, webdriver_update} = require('gulp-protractor')

# Build server's source code
gulp.task 'build-src', ->
  gulp.src 'src/**/*.coffee'
    .pipe coffee(bare: true).on 'error', gutil.log
    .pipe gulp.dest '.app/'

# Build jade templates
gulp.task 'build-jade', ->
  gulp.src '[assets/js/**/*.jade, !assets/js/includes/*.jade]'
    .pipe jade()
    .pipe gulp.dest 'public/partials'

# Build test's source code
gulp.task 'build-spec', ['build'], ->
  gulp.src 'spec/**/*.coffee'
    .pipe coffee().on 'error', gutil.log
    .pipe gulp.dest '.spec/'

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
    .pipe jasmine()

# Downloads the selenium webdriver
gulp.task 'webdriver-update', webdriver_update

# Run e2e tests
gulp.task 'test-e2e', ['build-spec', 'webdriver-update'], ->
  gulp.src [".e2e-tests/**/*[sS]pec.js"]
    .pipe protractor
      configFile: 'e2e-tests/protractor.config.js',
      args: ['--baseUrl', 'http://127.0.0.1:8000']

# Build application's code
gulp.task 'build', ['build-src', 'build-jade'], ->

# Run all tests
gulp.task 'test', ['test-server', 'test-client'], ->

# Run development server
gulp.task 'run-server', ->
  server.run ['bin/www']

# Reload development server
gulp.task 'reload', ->
  server.notify()

# Watch for changes in source code
gulp.task 'watch', ->
  gulp.watch 'src/**/*.coffee', ['build-src', ['reload']]
  gulp.watch 'assets/js/**/*.jade', ['build-jade', ['reload']]

# Generate docs
gulp.task 'docs', ->
  gulp.src 'src/**/*.coffee'
    .pipe docco()
    .pipe gulp.dest 'docs/server'
  gulp.src 'assets/js/**/*.coffee'
    .pipe docco()
    .pipe gulp.dest 'docs/client'

# Default task run a development server
gulp.task 'default', ['run-server', 'watch']
