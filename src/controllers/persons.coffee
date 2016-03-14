mongoose = require 'mongoose'
Person = require '../models/person'


module.exports =
  list: (req, res) ->
    Person.fin {}, (err, post) ->
      res.send posts

  detail: (req, res) ->
  create: (req, res) ->
  update: (req, res) ->
  delete: (req, res) ->
  
