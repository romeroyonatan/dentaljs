# Accounting
# ----------------------
# This module implements CRUD methods for accounting's collection
Accounting = require '../models/accounting'

module.exports =

  # Get a list of accounting filtered by person _id
  list: (req, res) ->
    Accounting.find req.query, (err, list)->
      if err
        res.send err
      res.send list

  # Create a new accounting
  create: (req, res) ->
    object = req.body
    object = new Accounting object
    object.save (err) ->
      if not err
        res.send object

  # Update an existing accounting
  update: (req, res) ->
    object = req.body
    Accounting.where(_id: req.params.id).update object, ->
      res.send object

  # Get details from an accounting
  detail: (req, res) ->
    Accounting.findOne _id: req.params.id, (err, object)->
      res.send object

  # Delete a accounting
  delete: (req, res) ->
    Accounting.find(_id: req.params.id).remove ->
      res.send "#{req.params.id} deleted"
