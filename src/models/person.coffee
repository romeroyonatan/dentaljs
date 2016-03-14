mongoose = require 'mongoose'

# Person model
Person = new mongoose.Schema
  first_name: String
  last_name: String
  phone: String
  slug: String

module.exports = mongoose.model 'Person', Person
