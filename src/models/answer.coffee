mongoose = require 'mongoose'

# Answer
# ===========================================================================
# Represent a Answer of a questionary
Answer = new mongoose.Schema
  Person: type: Schema.Types.ObjectId, ref: 'Person', required: yes
  Question: type: Schema.Types.ObjectId, ref: 'Question', required: yes
  choices: [String]
  comment: String
  date: type: Date, required: yes

module.exports = mongoose.model 'Answer', Answer
