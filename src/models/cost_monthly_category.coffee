mongoose = require 'mongoose'

CostMonthlyItem = new mongoose.Schema
  name: String

###
# Monthly cost category model
# ---------------------------------------------------------------------------
###
CostMonthlyCategory = new mongoose.Schema
  name: String
  items = [CostMonthlyItem]

module.exports =
  CostMonthlyItem: mongoose.model 'CostMonthlyItem', CostMonthlyItem
  CostMonthlyCategory: mongoose.model 'CostMonthlyCategory', CostMonthlyCategory
