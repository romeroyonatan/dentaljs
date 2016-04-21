express = require 'express'
controller = require '../controllers/accounting'

router = express.Router()


###
# REST API
###
router.get '/', controller.list
router.post '/', controller.create
router.get '/:id', controller.detail
router.put '/:id', controller.update
router.delete '/:id', controller.delete

###
# ## Another utils methods
###
router.get '/balance/:person', controller.balance

module.exports = router
