express = require 'express'
controller = require '../controllers/odontogram'

router = express.Router()

# ## REST API
router.get '/', controller.list
router.post '/', controller.create
router.get '/:id', controller.detail
router.put '/:id', controller.update
router.delete '/:id', controller.remove

module.exports = router
