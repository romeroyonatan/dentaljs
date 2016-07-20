express = require 'express'
controller = require '../controllers/costs'

router = express.Router()


# Costs routes
# ----------------------------------------------------------------------------
router.get '/categories/month', controller.monthlyCostCategories
router.post '/month', controller.monthlyCostSave
router.get '/month/:year/:month', controller.monthlyCost
router.get '/total/:year/:month', controller.monthlyCostSum

module.exports = router
