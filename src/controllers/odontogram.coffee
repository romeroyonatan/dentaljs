# Odontogram's Controller
# ----------------------
# This module implements CRUD methods for odontogram's collection

Odontogram = require '../models/odontogram'
Issue = require '../models/issue'

module.exports =
  # Obtains a list of Odontograms
  list: (req, res, next) ->
    Odontogram.find req.query
    .then (list) ->
      res.send list
    .catch (err) ->
      console.error err
      next err

  # Creates a new Odontogram
  create: (req, res, next) ->
    Odontogram.create req.body
    .then (object) ->
      res.status 201
      res.send object
    .catch (err) ->
      console.error err
      next err

  # Updates data of a Odontogram
  update: (req, res, next) ->
    object = req.body
    Odontogram.update _id: req.params.id, object
    .then (rawResponse) ->
      if not rawResponse.ok
        return next status: 404, message: 'Odontogram not found'
      res.send req.body
    .catch (err) ->
      console.error err
      next err

  # Get details of a Odontogram
  detail: (req, res, next) ->
    Odontogram.findOne _id: req.params.id
    .populate 'pieces.sectors.issue'
    .then (object) ->
      if not object?
        return next status: 404, message: 'Odontogram not found'
      res.send object
    # Error handling
    .catch (err) ->
      console.error err
      next err

  # Remove a existing Odontogram
  remove: (req, res, next) ->
    Odontogram.remove _id: req.params.id, (err, obj) ->
      console.error err if err
      res.status 204
      res.end()

  # Get issue list
  issues: (req, res, next) ->
    Issue.find req.query
    .then (list) ->
      res.send list
    .catch (err) ->
      console.error err
      next err
