# Costs
# ----------------------
# This module implements methods for costs's management
CostMonthlyCategory = require('../models/cost_monthly_category')
                      .CostMonthlyCategory
CostMonthlyItem = require('../models/monthly_cost')
Product = require('../models/product')
ProductPrice = require('../models/product_price')

module.exports = {
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

  # productList
  # --------------------------------------------------------------------------
  # List created product
  productList: (req, res, next) ->
    Product.find().then (list) -> res.send(list)
                  .catch (err) -> next(err)

  # productCreate
  # --------------------------------------------------------------------------
  # Create new product
  productCreate: (req, res, next) ->
    Product.create(req.body)
    .then (item) -> res.status(201).send(item)
    .catch (err) -> next err

  # productUpdate
  # --------------------------------------------------------------------------
  # Update a product
  productUpdate: (req, res, next) ->
    Product.findByIdAndUpdate(req.params.id, req.body)
    .then (item) -> res.send(item)
    .catch (err) -> next err

  # productDelete
  # --------------------------------------------------------------------------
  # Remove a product
  productDelete: (req, res, next) ->
    Product.findByIdAndRemove(req.params.id)
    .then () -> res.status(204).end()
    .catch (err) -> next err

  # productDetail
  # --------------------------------------------------------------------------
  # Get details of a product
  productDetail: (req, res, next) ->
    Product
      .findById(req.params.id)
      .then (product) ->
        if product?
          # obtengo lista de precios cargadas para ese producto
          ProductPrice.find(product: product).then (prices) ->
            # combino resultado de ambas consultas en un solo objeto
            object = Object.assign {}, product.toObject(), prices: prices
            res.send(object)
        else
          next status: 404, message: "Product #{req.params.id} not found"
    .catch (err) -> next err

  # productPricesCreate
  # --------------------------------------------------------------------------
  # Create new price list.
  #
  # This method expect a list of product's prices in request body
  productPricesCreate: (req, res, next) ->
    # create new prices
    promises = (ProductPrice.create price for price in req.body)
    Promise
      .all(promises)
      .then (obj) -> res.status(201).send(obj)
      .catch (err) -> next err

  # directCostReport
  # --------------------------------------------------------------------------
  # Retrieve a report which shows the last price, the performance rate and
  # use-price for each product
  directCostReport: (req, res, next) ->
    result = []
    promises = []
    Product.find().then (products) ->
      products.forEach (product) ->
        promises.push(
          ProductPrice
          .findOne(product:product, "-product -_id")
          .sort('-date')
          .exec()
          .then (price) ->
            if price?
              object = Object.assign {}, price.toObject(), product.toObject()
              object.use_price = object.price / object.performance_rate
            else
              object = product.toObject()
            result.push object
        )
      Promise.all(promises).then ->
        res.send(result)
}
