express = require 'express'
controller = require '../controllers/accounting'

router = express.Router()


###
# ## Another utils methods
###
router.get '/balance/:person', controller.balance
router.get '/categories', controller.categories

###
# REST API
###
router.get '/', controller.list
router.post '/', controller.create
router.get '/:id', controller.detail
router.put '/:id', controller.update
router.delete '/:id', controller.delete

module.exports = router
