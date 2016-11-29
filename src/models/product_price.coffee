mongoose = require 'mongoose'

ProductPrice = new mongoose.Schema
  product: type: mongoose.Schema.Types.ObjectId, ref: 'Product', required: true
  price: Number
  date: type: Date, default: Date.now
  source: String

module.exports = mongoose.model 'ProductPrice', ProductPrice
