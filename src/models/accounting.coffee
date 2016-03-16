mongoose = require 'mongoose'

# Person model
Accounting = new mongoose.Schema
  person: mongoose.Schema.Types.ObjectId
  description: String
  amount: Number
  date: { type: Date, default: Date.now },

module.exports = mongoose.model 'Accounting', Accounting
