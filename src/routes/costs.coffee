express = require 'express'
controller = require '../controllers/costs'

router = express.Router()


# Costs routes
# ----------------------------------------------------------------------------
router.get '/categories/month', controller.monthlyCostCategories
router.post '/month', controller.monthlyCostSave
router.get '/month/:year/:month', controller.monthlyCost
router.get '/total/:year/:month', controller.monthlyCostSum

router.get '/direct/products', controller.productList
router.get '/direct/products/:id', controller.productDetail
router.post '/direct/products', controller.productCreate
router.post '/direct/prices', controller.productPricesCreate
router.get '/direct/', controller.directCostReport

module.exports = router
