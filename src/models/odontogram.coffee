mongoose = require 'mongoose'
Person = require './person'
Issue = require './issue'

# ## Piece model
Piece = new mongoose.Schema
  id: Number
  sectors: [
    id: Number,
    issue: String
      #type: mongoose.Schema.Types.ObjectId
      #ref: Issue
  ]

# ## Odontogram model
Odontogram = new mongoose.Schema
  person: type: mongoose.Schema.Types.ObjectId, ref: Person
  title: String
  comments: String
  pieces: [Piece]

module.exports = mongoose.model 'Odontogram', Odontogram
