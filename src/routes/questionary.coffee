express = require 'express'
controller = require '../controllers/questionary'

router = express.Router()

router.get '/:person', controller.answers
router.post '/:person', controller.update
router.get '/', controller.list

module.exports = router
