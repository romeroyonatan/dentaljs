express = require 'express'
multipartMiddleware = require('connect-multiparty')()
controller = require '../controllers/image'
router = express.Router()

# Images routes
# --------------------------------------
router.post '/:slug', multipartMiddleware,
                      controller.validate,
                      controller.create
router.post '/:slug/:foldername', multipartMiddleware,
                                  controller.validate,
                                  controller.create
router.get '/:slug', controller.list
router.get '/:slug/:foldername', controller.list
router.delete '/:id', controller.remove
router.put '/:id', controller.update

module.exports = router
