# Person's Controller
# ----------------------
# This module implements CRUD methods for accounting's collection

Person = require '../models/person'

module.exports =
  # Obtains a list of persons
  list: (req, res) ->
    Person.find (err, list)->
      res.send list

  # Creates a new person
  create: (req, res) ->
    object = new Person req.body
    object.save (err) ->
      if not err
        res.send object

  # Updates data of a person
  update: (req, res) ->
    object = req.body
    Person.where(slug: req.params.slug).update object, ->
      res.send req.body

  # Get details of a person
  detail: (req, res) ->
    Person.findOne slug: req.params.slug, (err, object) ->
      res.send object

  # Remove a exiting person
  delete: (req, res) ->
    Person.findOne(slug: req.params.slug).remove ->
      res.send "#{req.params.slug} deleted"
