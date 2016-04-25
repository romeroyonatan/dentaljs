mongoose = require 'mongoose'

# ## Issue model
Issue = new mongoose.Schema
  code: String
  description: String
  # ### Issue's types:
  # 1. Disease
  # 2. Fix
  type: Number

module.exports = mongoose.model 'Issue', Issue
