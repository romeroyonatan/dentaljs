mongoose = require 'mongoose'

ProductPrice = new mongoose.Schema
  product: type: mongoose.Schema.Types.ObjectId, ref: 'Product', required: true
  price: Number
  date_init: type: Date, default: Date.now
  date_end: Date
  source: String

module.exports = mongoose.model 'ProductPrice', ProductPrice
