express = require 'express'
controller = require '../controllers/person'

router = express.Router()

###
# REST API
###
router.get '/', controller.list
router.post '/', controller.create
router.get '/:slug', controller.detail
router.put '/:slug', controller.update
router.delete '/:slug', controller.remove

module.exports = router
