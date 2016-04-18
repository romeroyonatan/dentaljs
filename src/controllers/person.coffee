# Person's Controller
# ----------------------
# This module implements CRUD methods for accounting's collection

Person = require '../models/person'

module.exports =
  # Obtains a list of persons
  list: (req, res, next) ->
    Person.find (err, list)->
      if err
        return next err
      res.send list

  # Creates a new person
  create: (req, res, next) ->
    object = new Person req.body
    object.save (err) ->
      if err
        return next err
      res.status 201
      res.send object

  # Updates data of a person
  update: (req, res, next) ->
    object = req.body
    Person.update slug: req.params.slug, object, (err, rawResponse) ->
      if err
        return next err
      if not rawResponse.ok
        return next status: 404, message: 'Person not found'
      res.send req.body

  # Get details of a person
  detail: (req, res, next) ->
    Person.findOne slug: req.params.slug, (err, object) ->
      # Error handling
      if err
        return next err
      if not object?
        return next status: 404, message: 'Person not found'
      res.send object

  # Remove a exiting person
  remove: (req, res, next) ->
    Person.findOne(slug: req.params.slug).remove ->
      res.status 204
      res.end()
