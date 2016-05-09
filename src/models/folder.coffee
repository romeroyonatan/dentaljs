mongoose = require 'mongoose'

# ## Issue model
Folder = new mongoose.Schema
  person: type: mongoose.Schema.Types.ObjectId, ref: 'Person', required: true
  parent: type: mongoose.Schema.Types.ObjectId, ref: 'Folder'
  name: type: String, required: true
  created: type: Date, default: Date.now

module.exports = mongoose.model 'Folder', Folder
