mongoose = require 'mongoose'

# Person model
Accounting = new mongoose.Schema
  person: mongoose.Schema.Types.ObjectId
  description: String
  debit: Number
  assets: {type: Number, default: 0, min: 0}
  balance: {type: Number, default: 0, min: 0}
  date: { type: Date, default: Date.now },
  # parent id
  parent: mongoose.Schema.Types.ObjectId
  childs: [mongoose.Schema.Types.ObjectId]

Accounting.pre 'save', (next) ->
  @assets = 0 if not @assets?
  @debit = 0 if not @debit?
  @balance = @assets - @debit

module.exports = mongoose.model 'Accounting', Accounting
