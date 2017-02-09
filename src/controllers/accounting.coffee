# Accounting
# ----------------------
# This module implements CRUD methods for accounting's collection
Accounting = require '../models/accounting'
AccountingCategory = require '../models/accounting_category'
email = require '../utils/email'
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
      # send mail to patient
      email.send_current_account object.person

      return res.send object if not object.parent

      # update parent child list
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
      return next err if err
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
      res.send balance: balance, size: list.length

  # categories
  # --------------------------------------------------------------------------
  # Get list of availables categories
  categories: (req, res, next) ->
    AccountingCategory.find {}, (err, list) ->
      res.send list
      return next err if err

  # categories_detail
  # --------------------------------------------------------------------------
  # Get details of category with the number of accounting which its type is
  # equal to category
  category_detail: (req, res, next) ->
    AccountingCategory.findById req.params.id, (err, category) ->
      return next err if err
      return next status: 404, message: 'Not found' if not category?
      Accounting.count category: category._id, (err, count) ->
        return next err if err
        obj = category.toObject()
        #obj.childs_count = count
        res.send obj
