# Accounting
# ----------------------
# This module implements CRUD methods for accounting's collection
Accounting = require '../models/accounting'
AccountingCategory = require '../models/accounting_category'
mongoose = require 'mongoose'

module.exports =

  # list
  # --------------------------------------------------------------------------
  # Get a list of accounting filtered by person _id
  list: (req, res, next) ->
    req.query.parent = null
    Accounting.find(req.query)
      .populate('childs')
      .exec (err, list) ->
        return next err if err
        res.send list

  # create
  # --------------------------------------------------------------------------
  # Create a new accounting
  create: (req, res, next) ->
    Accounting.create req.body, (err, object) ->
      return next err if err
      res.status 201
      return res.send object if not object.parent
      Accounting.findOne _id: object.parent, (err, parent) ->
        return next err if err
        if parent
          parent.childs.push object
          parent.save (err, parent)->
            res.send object

  # update
  # --------------------------------------------------------------------------
  # Update an existing accounting
  update: (req, res, next) ->
    object = req.body
    # update balance because Mongoose doesnt do in pre-save hook
    object.balance = object.assets - object.debit
    Accounting.update _id: req.params.id, object, (err)->
      if not err
        res.status = 200
        res.send object

  # detail
  # --------------------------------------------------------------------------
  # Get details from an accounting
  detail: (req, res, next) ->
    Accounting.findById req.params.id, (err, object) ->
      res.send object

  # delete
  # --------------------------------------------------------------------------
  # Delete a accounting
  delete: (req, res, next) ->
    Accounting.remove _id: req.params.id, (err, account)->
      return next err if err
      # check if account has parent
      if account.parent?
        Accounting.update { _id: account.parent },
                          {$pull: 'childs': _id: account._id}
      res.status 204
      res.end()

  # balance
  # --------------------------------------------------------------------------
  # Calculate the person's balance
  balance: (req, res, next) ->
    Accounting.find person: req.params.person, (err, list)->
      return next err if err
      balance = 0
      for account in list
        balance += account.assets
        balance -= account.debit
      res.send balance: balance

  # categories
  # --------------------------------------------------------------------------
  # Get list of availables categories
  categories: (req, res, next) ->
    AccountingCategory.find {}, (err, list) ->
      res.send list
      return next err if err
