express = require('express')
router = express.Router()

### GET home page. ###

router.get '/', (req, res, next) ->
  res.render 'index', title: 'Express'
  return

# Serve partials jade
router.get '/partials/:view/:name', (req, res) ->
   res.render "partials/#{req.params.view}/#{req.params.name}"

module.exports = router
