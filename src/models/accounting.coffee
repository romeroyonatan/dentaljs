mongoose = require 'mongoose'

# Person model
Accounting = new mongoose.Schema
  person: mongoose.Schema.Types.ObjectId
  side: String
  piece:
    type: Number
    require: false
    validate:
      validator: (v)->
        11 <= v <= 18 or
        21 <= v <= 28 or
        31 <= v <= 38 or
        41 <= v <= 48
      message: "Invalid piece."
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
