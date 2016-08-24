# Costs
# ----------------------
# This module implements methods for costs's management
CostMonthlyCategory = require('../models/cost_monthly_category')
                      .CostMonthlyCategory
CostMonthlyItem = require('../models/monthly_cost')

module.exports =
  # monthlyCostCategories
  # --------------------------------------------------------------------------
  # Get a list of monthly costs categories
  monthlyCostCategories: (req, res, next) ->
    CostMonthlyCategory.find().exec (err, list) ->
      return next err if err
      res.send list

  # monthlyCostSave
  # --------------------------------------------------------------------------
  # Save a monthly cost list
  monthlyCostSave: (req, res, next) ->
    promises = for cost in req.body
      if cost._id?
        CostMonthlyItem.findByIdAndUpdate cost._id, cost, upsert:yes
      else
        CostMonthlyItem.create cost
    Promise.all(promises)
      .then -> res.end()
      .catch (err) -> next err

  # monthlyCost
  # --------------------------------------------------------------------------
  # Get monthly cost
  monthlyCost: (req, res, next) ->
    month = parseInt req.params.month - 1
    year = parseInt req.params.year
    min = new Date year, month, 1
    max = new Date year, month + 1, 1
    CostMonthlyItem.find date: $gte: min, $lt: max, (err, list) ->
      return next err if err
      res.send list

  # monthlyCostSum
  # --------------------------------------------------------------------------
  # Get sum monthly cost
  monthlyCostSum: (req, res, next) ->
    month = parseInt req.params.month - 1
    year = parseInt req.params.year
    min = new Date year, month, 1
    max = new Date year, month + 1, 1
    CostMonthlyItem.find date: $gte: min, $lt: max, (err, list) ->
      return next err if err
      # TODO Ver como hacer suma en mongoose
      sum = 0
      list.forEach (item) ->
        sum += item.price
      res.send total: sum
