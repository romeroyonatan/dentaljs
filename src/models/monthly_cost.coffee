mongoose = require 'mongoose'

###
# Monthly cost model
# ---------------------------------------------------------------------------
###
MonthlyCost = new mongoose.Schema
  date: type: Date, required: yes
  price: type: Number, required: yes
  category: type: mongoose.Schema.Types.ObjectId,
            ref: 'CostMonthlyItem'
            required: yes

module.exports = mongoose.model 'MonthlyCost', MonthlyCost
