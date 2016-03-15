express = require 'express'
person_routes = require './person'

router = express.Router()

### GET home page. ###
router.get '/', (req, res, next) ->
  res.render 'index', title: ''

# Call person routes
router.use '/persons', person_routes

# simple session authorization
checkAuth = (req, res, next) ->
  unless req.session.authorized
    res.statusCode = 401
    res.render '401', 401
  else
    next()

module.exports = router
