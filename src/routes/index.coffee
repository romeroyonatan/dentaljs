express = require 'express'
person_routes = require './person'

router = express.Router()

### GET home page. ###
router.get '/', (req, res, next) ->
  res.render 'index', title: ''

# Serve partials jade
router.get '/partials/:view/:name', (req, res) ->
   res.render "partials/#{req.params.view}/#{req.params.name}"

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
