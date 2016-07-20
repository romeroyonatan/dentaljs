express = require 'express'
persons = require './person'
accouting = require './accounting'
odontograms = require './odontogram'
images = require './image'
folders = require './folder'
questions = require './questionary'
costs = require './costs'
exec = require('child_process').exec

router = express.Router()

# get build's version
version = "0.2.0"
if not version?
  exec 'git describe --tags', (err, stdout) -> version = stdout

### GET home page. ###
router.get '/', (req, res, next) ->
  res.render 'index', {title: 'Alejandro Lezcano', version: version}

# Call person routes
router.use '/persons', persons
router.use '/accounting', accouting
router.use '/odontograms', odontograms
router.use '/images', images
router.use '/folders', folders
router.use '/questions', questions
router.use '/costs', costs

# simple session authorization
checkAuth = (req, res, next) ->
  unless req.session.authorized
    res.statusCode = 401
    res.render '401', 401
  else
    next()

module.exports = router
