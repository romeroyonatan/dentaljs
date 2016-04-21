mongoose = require 'mongoose'

# Person model
Accounting = new mongoose.Schema
  person: mongoose.Schema.Types.ObjectId
  description: String
  debit: {type: Number, default: 0, min: 0}
  assets: {type: Number, default: 0, min: 0}
  balance: {type: Number, default: 0}
  date: { type: Date, default: Date.now },
  # parent id
  parent: type: mongoose.Schema.Types.ObjectId, ref: 'Accounting'
  childs: [type: mongoose.Schema.Types.ObjectId, ref: 'Accounting']

# Pre-save Hook that calculates balance amount
Accounting.pre 'save', (next) ->
  @assets = 0 if not @assets?
  @debit = 0 if not @debit?
  @balance = @assets - @debit
  next()

module.exports = mongoose.model 'Accounting', Accounting
