mongoose = require 'mongoose'

# Person model
Accounting = new mongoose.Schema
  person: mongoose.Schema.Types.ObjectId
  description: String
  amount: Number
  date: { type: Date, default: Date.now },
  # id de accounting que este registro invalida
  invalid: mongoose.Schema.Types.ObjectId
  # id de accounting que este registro paga
  pay: mongoose.Schema.Types.ObjectId

module.exports = mongoose.model 'Accounting', Accounting
