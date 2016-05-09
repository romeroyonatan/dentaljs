express = require 'express'
multipartMiddleware = require('connect-multiparty')()
controller = require '../controllers/image'

router = express.Router()

# Images routes
# --------------------------------------
router.post '/:slug', multipartMiddleware, controller.validate,
                      controller.create
router.get '/:slug', controller.list
router.remove '/:id', controller.remove

module.exports = router
