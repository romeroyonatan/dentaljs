mongoose = require 'mongoose'
fs = require 'fs'
config = require '../config'

# ## Issue model
Image = new mongoose.Schema
  person: type: mongoose.Schema.Types.ObjectId, ref: 'Person'
  folder: type: mongoose.Schema.Types.ObjectId, ref: 'Folder'
  path: type: String, required: on
  description: String
  date: type: Date, default: Date.now

# remove file after remove image
Image.post 'remove', (image) ->
  fs.unlink config.MEDIA_ROOT + image.path

module.exports = mongoose.model 'Image', Image
