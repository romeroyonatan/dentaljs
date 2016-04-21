# Accounting
# ----------------------
# This module implements CRUD methods for accounting's collection
Accounting = require '../models/accounting'
mongoose = require 'mongoose'

module.exports =

  # Get a list of accounting filtered by person _id
  list: (req, res, next) ->
    req.query.parent = null
    Accounting.find(req.query).populate('childs').exec (err, list) ->
      if err
        next err
      res.send list

  # Create a new accounting
  create: (req, res, next) ->
    Accounting.create req.body, (err, object) ->
      return next err if err
      res.status 201
      return res.send object if not object.parent
      Accounting.findOne _id: object.parent, (err, parent) ->
        if parent
          parent.childs.push object
          parent.save (err, parent)->
            res.send object

  # Update an existing accounting
  update: (req, res) ->
    object = req.body
    # update balance because Mongoose doesnt do in pre-save hook
    object.balance = object.assets - object.debit
    Accounting.update _id: req.params.id, object, (err)->
      if not err
        res.status = 200
        res.send object

  # Get details from an accounting
  detail: (req, res) ->
    Accounting.findOne _id: req.params.id, (err, object) ->
      res.send object

  # Delete a accounting
  delete: (req, res) ->
    Accounting.remove _id: req.params.id, ->
      res.send "#{req.params.id} deleted"
