mongoose = require 'mongoose'
URLSlugs = require 'mongoose-url-slugs' 

# Person model
Person = new mongoose.Schema
  first_name: String
  last_name: String
  phone: String

# Generate slug
Person.plugin URLSlugs 'first_name last_name'

module.exports = mongoose.model 'Person', Person
