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
      console.log object
      res.send object
    .catch (err) ->
      console.error err
      next err

  # Updates data of a Odontogram
  update: (req, res, next) ->
    object = req.body
    Odontogram.update id: req.params.id, object
    .then (rawResponse) ->
      if not rawResponse.ok
        return next status: 404, message: 'Odontogram not found'
      res.send req.body
    .catch (err) ->
      console.error err
      next err

  # Get details of a Odontogram
  detail: (req, res, next) ->
    Odontogram.findOne id: req.params.id
    .populate 'pieces.sectors.issue'
    .then (object) ->
      if not object?
        return next status: 404, message: 'Odontogram not found'
      res.send object
    # Error handling
    .catch (err) ->
      console.error err
      next err

  # Remove a exiting Odontogram
  remove: (req, res, next) ->
    Odontogram.remove id: req.params.id
    .then ->
      res.status 204
      res.end()
    .catch (err) ->
      console.error err
      next err

  # Get issue list
  issues: (req, res, next) ->
    Issue.find req.query
    .then (list) ->
      res.send list
    .catch (err) ->
      console.error err
      next err
