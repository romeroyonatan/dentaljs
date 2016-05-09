express = require 'express'
multipartMiddleware = require('connect-multiparty')()
controller = require '../controllers/image'

router = express.Router()

# Images routes
# --------------------------------------
router.post '/:slug', multipartMiddleware, controller.create
router.get '/:id', controller.list

module.exports = router
