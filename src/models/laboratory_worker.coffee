mongoose = require 'mongoose'
URLSlugs = require 'mongoose-url-slugs'

LaboratoryWorker = new mongoose.Schema
  name: type: String, required: true

# Generate slug
LaboratoryWorker.plugin URLSlugs 'name'

module.exports = mongoose.model 'LaboratoryWorker', LaboratoryWorker
