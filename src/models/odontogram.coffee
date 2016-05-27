mongoose = require 'mongoose'
Person = require './person'
Issue = require './issue'

# ## Piece model
Piece = new mongoose.Schema
  id: type: Number, required: yes
  issue: String
  sectors: [
    id: Number,
    issue:
      type: mongoose.Schema.Types.ObjectId
      ref: 'Issue'
  ]

# ## Odontogram model
Odontogram = new mongoose.Schema
  person: type: mongoose.Schema.Types.ObjectId, ref: Person
  date: type: Date, default: Date.now
  title: String
  comments: String
  pieces: [Piece]

module.exports = mongoose.model 'Odontogram', Odontogram
