express = require 'express'
controller = require '../controllers/email'
router = express.Router()

router.post '/current_account/:person_id', controller.send_current_account

module.exports = router
