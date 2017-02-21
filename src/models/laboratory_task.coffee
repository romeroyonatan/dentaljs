mongoose = require 'mongoose'

LaboratoryTask = new mongoose.Schema
  worker: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'LaboratoryWorker',
    required: true,
  }
  name: type: String, required: yes
  date: type: Date, default: Date.now
  debit: {type: Number, default: 0, min: 0}
  assets: {type: Number, default: 0, min: 0}
  balance: {type: Number, default: 0}

# Pre-save Hook that calculates balance amount
LaboratoryTask.pre 'save', (next) ->
  @assets = 0 if not @assets?
  @debit = 0 if not @debit?
  @balance = @assets - @debit
  next()

module.exports = mongoose.model 'LaboratoryTask', LaboratoryTask
