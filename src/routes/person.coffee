express = require 'express'
multipartMiddleware = require('connect-multiparty')()
controller = require '../controllers/person'

router = express.Router()

# Images routes
# --------------------------------------
router.post '/:slug/photos', multipartMiddleware, controller.uploadImage
router.get '/:id/photos', controller.listImages

# REST API
# =======================================
router.get '/', controller.list
router.post '/', controller.create
router.get '/:slug', controller.detail
router.put '/:slug', controller.update
router.delete '/:slug', controller.remove

module.exports = router
