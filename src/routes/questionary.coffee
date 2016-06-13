express = require 'express'
controller = require '../controllers/questionary'

router = express.Router()

router.get '/:person', controller.list
router.post '/:person', controller.update
router.get '/', controller.list

module.exports = router
