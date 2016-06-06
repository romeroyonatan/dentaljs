mongoose = require 'mongoose'

# Question
# ===========================================================================
# Represent a Question of a questionary
Question = new mongoose.Schema
  statement: type: String, required: yes
  choices: [[title: String]] # support for grouped choices
  multiple_choice: Boolean
  can_comment: Boolean
  comment_title: String # text that will showed before comment input
  help_text: String
  depends: type: Schema.Types.ObjectId, ref: 'Question'
  category: type: Schema.Types.ObjectId, ref: 'QuestionCategory'

module.exports = mongoose.model 'Question', Question
