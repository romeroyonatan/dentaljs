fs            = require 'fs'
wrench        = require 'wrench'
{print}       = require 'util'
which         = require 'which'
{spawn, exec} = require 'child_process'

# ANSI Terminal Colors
bold  = '\x1B[0;1m'
red   = '\x1B[0;31m'
green = '\x1B[0;32m'
reset = '\x1B[0m'

pkg = JSON.parse fs.readFileSync('./package.json')
testCmd = pkg.scripts.test
startCmd = pkg.scripts.start


log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

# Compiles app.coffee and src directory to the .app directory
build = (callback) ->
  options = ['-o', 'public/partials', 'assets/js']
  cmd = 'node_modules/jade/bin/jade.js'
  jade = spawn cmd, options
  jade.on 'exit', (status) ->
    if status is 0
      options = ['-c','-b', '-o', '.app', 'src']
      cmd = which.sync 'coffee'
      coffee = spawn cmd, options
      coffee.stdout.pipe process.stdout
      coffee.stderr.pipe process.stderr
      coffee.on 'exit', (status) -> callback?() if status is 0

# mocha test
test = (callback) ->
  options = [
    'start'
    'karma.conf.js'
    '--single-run'
  ]
  try
    cmd = 'node_modules/karma/bin/karma'
    spec = spawn cmd, options
    spec.stdout.pipe process.stdout
    spec.stderr.pipe process.stderr
    spec.on 'exit', (status) ->
      if status is 0
        callback?()
      else
        process.exit status
  catch err
    log err.message, red
    log 'Karma is not installed - try npm install', red

task 'docs', 'Generate annotated source code with Docco', ->
  files = wrench.readdirSyncRecursive("src")
  files = ("./#{file}" for file in files when /\.coffee$/.test file)
  log files
  try
    cmd ='./node_modules/.bin/docco-husky'
    docco = spawn cmd, files
    docco.stdout.pipe process.stdout
    docco.stderr.pipe process.stderr
    docco.on 'exit', (status) -> callback?() if status is 0
  catch err
    log err.message, red
    log 'Docco is not installed - try npm install docco -g', red


task 'build', ->
  build -> log ":)", green

task 'spec', 'Run Mocha tests', ->
  build -> test -> log ":)", green

task 'test', 'Run Mocha tests', ->
  build -> test -> log ":)", green

task 'dev', 'start dev env', ->
  # watch_coffee
  options = ['-c', '-b', '-w', '-o', '.app', 'src']
  cmd = which.sync 'coffee'
  coffee = spawn cmd, options
  coffee.stdout.pipe process.stdout
  coffee.stderr.pipe process.stderr
  log 'Watching coffee files', green
  # watch_js
  supervisor = spawn 'node', [
    './node_modules/supervisor/lib/cli-wrapper.js',
    '-w',
    '.app,views',
    '-e',
    'js,jade',
    'bin/www'
  ]
  supervisor.stdout.pipe process.stdout
  supervisor.stderr.pipe process.stderr
  log 'Watching js files and running server', green

task 'debug', 'start debug env', ->
  # watch_coffee
  options = ['-c', '-b', '-w', '-o', '.app', 'src']
  cmd = which.sync 'coffee'
  coffee = spawn cmd, options
  coffee.stdout.pipe process.stdout
  coffee.stderr.pipe process.stderr
  log 'Watching coffee files', green
  # run debug mode
  app = spawn 'node', [
    '--debug',
    'server'
  ]
  app.stdout.pipe process.stdout
  app.stderr.pipe process.stderr
  # run node-inspector
  inspector = spawn 'node-inspector'
  inspector.stdout.pipe process.stdout
  inspector.stderr.pipe process.stderr
  # run google chrome
  chrome = spawn 'google-chrome', ['http://0.0.0.0:8080/debug?port=5858']
  chrome.stdout.pipe process.stdout
  chrome.stderr.pipe process.stderr
  log 'Debugging server', green
