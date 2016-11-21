mongoose = require 'mongoose'

Product = new mongoose.Schema
  name: type: String, required: true
  performance_rate: Number
  category: String

module.exports = mongoose.model 'Product', Product
