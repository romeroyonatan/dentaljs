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
    Odontogram.create req.body, (err, object) ->
      return next err if err
      res.status 201
      res.send object

  # Updates data of a Odontogram
  update: (req, res, next) ->
    Odontogram.update _id: req.params.id, req.body, (err, rawResponse) ->
      return next err if err
      if not rawResponse.ok
        return next status: 404, message: 'Odontogram not found'
      res.send req.body

  # Get details of a Odontogram
  detail: (req, res, next) ->
    Odontogram.findOne _id: req.params.id
    .populate 'pieces.sectors.issue'
    .then (object) ->
      if not object?
        return next status: 404, message: 'Odontogram not found'
      res.send object
    # Error handling
    , (err) ->
      console.error err
      next err

  # Remove a existing Odontogram
  remove: (req, res, next) ->
    Odontogram.remove _id: req.params.id, (err, obj) ->
      return next err if err
      res.status 204
      res.end()

  # Get issue list
  issues: (req, res, next) ->
    Issue.find req.query, (err, list) ->
      return next err if err
      res.send list
