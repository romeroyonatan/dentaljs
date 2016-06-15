# Questionary
# ----------------------
# This module implements methods for Question's collection
Question = require '../models/question'
Answer = require '../models/answer'
mongoose = require 'mongoose'

module.exports =

  # list
  # --------------------------------------------------------------------------
  # Get a list of questions
  list: (req, res, next) ->
    req.query.parent = null
    Question.find().exec (err, list) ->
      return next err if err
      res.send list

  # update
  # --------------------------------------------------------------------------
  # Update a questionary
  update: (req, res, next) ->
    promises = for answer in req.body.answers
      answer.person = req.params.person
      Answer.update
        person: answer.person, question: answer.question
        answer
        upsert: yes
    Promise.all(promises)
    .then -> res.end()
    .catch (err)-> next err

  # aswers
  # --------------------------------------------------------------------------
  # Get person's answers
  answers: (req, res, next) ->
    Answer.find(person: req.params.person)
          .populate("question", "statement")
          .exec (err, list)->
            return next err if err
            res.send list
