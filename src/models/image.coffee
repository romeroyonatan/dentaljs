mongoose = require 'mongoose'

# ## Issue model
Image = new mongoose.Schema
  person: type: mongoose.Schema.Types.ObjectId, ref: 'Person'
  path: type: String, required: on
  description: String

module.exports = mongoose.model 'Image', Image
