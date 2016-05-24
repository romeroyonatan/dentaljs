mongoose = require 'mongoose'
URLSlugs = require 'mongoose-url-slugs'

# Person model
Person = new mongoose.Schema
  first_name: type: String, required: true
  last_name: type: String, required: true
  born:
    date: Date
    city: String
    country: String
  identification: Number
  civil_status: Number
  email: String
  address:
    street: String
    number: Number
    district: String
    city: String
  phones:
    home: String
    cellphone: String
    work: String
  work:
    place: String
    hour: String
  consultation_reason: String
  tags: [String]

# Generate slug
Person.plugin URLSlugs 'first_name last_name'

module.exports = mongoose.model 'Person', Person
