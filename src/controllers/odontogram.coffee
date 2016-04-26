# Odontogram's Controller
# ----------------------
# This module implements CRUD methods for odontogram's collection

Odontogram = require '../models/odontogram'
Issue = require '../models/issue'

module.exports =
  # Obtains a list of Odontograms
  list: (req, res, next) ->
    Odontogram.find req.query, (err, list) ->
      return next err if err
      res.send list

  # Creates a new Odontogram
  create: (req, res, next) ->
    object = new Odontogram req.body
    object.save (err) ->
      return next err if err
      res.status 201
      res.send object

  # Updates data of a Odontogram
  update: (req, res, next) ->
    object = req.body
    Odontogram.update slug: req.params.slug, object, (err, rawResponse) ->
      return next err if err
      if not rawResponse.ok
        return next status: 404, message: 'Odontogram not found'
      res.send req.body

  # Get details of a Odontogram
  detail: (req, res, next) ->
    Odontogram.findOne slug: req.params.slug
    .populate 'pieces.sectors.issue'
    .then (object) ->
      if not object?
        return next status: 404, message: 'Odontogram not found'
      res.send object
    # Error handling
    .catch (err) -> next err

  # Remove a exiting Odontogram
  remove: (req, res, next) ->
    Odontogram.findOne(slug: req.params.slug).remove (err) ->
      return next err if err
      res.status 204
      res.end()

  # Get issue list
  issues: (req, res, next) ->
    Issue.find req.query, (err, list) ->
      return next err if err
      res.send list
