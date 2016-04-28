mongoose = require 'mongoose'

# ## Issue model
Image = new mongoose.Schema
  person: type: mongoose.Schema.Types.ObjectId, ref: 'Person'
  path: type: String, required: on
  description: String
  date: type: Date, default: Date.now

module.exports = mongoose.model 'Image', Image
