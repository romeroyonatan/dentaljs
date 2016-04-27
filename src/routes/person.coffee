express = require 'express'
multipartMiddleware = require('connect-multiparty')()
controller = require '../controllers/person'

router = express.Router()

# Photo uploadPhoto
# --------------------------------------
router.post '/:slug/photos', multipartMiddleware, controller.uploadPhoto

# REST API
# =======================================
router.get '/', controller.list
router.post '/', controller.create
router.get '/:slug', controller.detail
router.put '/:slug', controller.update
router.delete '/:slug', controller.remove

module.exports = router
