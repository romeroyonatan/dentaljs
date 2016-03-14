express = require('express')
router = express.Router()

### GET home page. ###
router.get '/', (req, res, next) ->
  res.render 'index', title: ''
  return

# Serve partials jade
router.get '/partials/:view/:name', (req, res) ->
   res.render "partials/#{req.params.view}/#{req.params.name}"

# Call index of controller
router.all '/:controller', (req, res, next) ->
  routeMvc(req.params.controller, 'index', req, res, next)

# Call method from controller
router.all '/:controller/:method', (req, res, next) ->
  routeMvc(req.params.controller, req.params.method, req, res, next)

# Call method from controller passing id
router.all '/:controller/:method/:id', (req, res, next) ->
  routeMvc(req.params.controller, req.params.method, req, res, next)


# render the page based on controller name, method and id
routeMvc = (controllerName='index', methodName='index', req, res, next) ->
  controller = null
  try
    controller = require "./controllers/" + controllerName
  catch e
    console.warn "controller not found: " + controllerName, e
    next()
    return
  data = null
  if typeof controller[methodName] is 'function'
    actionMethod = controller[methodName].bind controller
    actionMethod req, res, next
  else
    console.warn 'method not found: ' + methodName
    next()


# simple session authorization
checkAuth = (req, res, next) ->
  unless req.session.authorized
    res.statusCode = 401
    res.render '401', 401
  else
    next()

module.exports = router
