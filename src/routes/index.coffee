express = require 'express'
persons = require './person'
accouting = require './accounting'
odontograms = require './odontogram'
images = require './image'

router = express.Router()

### GET home page. ###
router.get '/', (req, res, next) ->
  res.render 'index', title: ''

# Call person routes
router.use '/persons', persons
router.use '/accounting', accouting
router.use '/odontograms', odontograms
router.use '/images', images

# simple session authorization
checkAuth = (req, res, next) ->
  unless req.session.authorized
    res.statusCode = 401
    res.render '401', 401
  else
    next()

module.exports = router
