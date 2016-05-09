express = require 'express'
controller = require '../controllers/folder'

router = express.Router()

# REST API
# =======================================
router.get '/:slug', controller.list
router.post '/:slug', controller.create
router.get '/:slug/:name', controller.detail
router.put '/:id', controller.update
router.delete '/:id', controller.remove

module.exports = router
