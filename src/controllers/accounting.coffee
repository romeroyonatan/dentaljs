Accounting = require '../models/accounting'

module.exports =

  list: (req, res) ->
    Accounting.find req.query, (err, list)->
      if err
        res.send err
      res.send list

  create: (req, res) ->
    object = req.body
    object = new Accounting object
    object.save (err) ->
      if not err
        res.send object

  update: (req, res) ->
    object = req.body
    Accounting.where(_id: req.params.id).update object, ->
      res.send object

  detail: (req, res) ->
    Accounting.findOne _id: req.params.id, (err, object)->
      res.send object

  delete: (req, res) ->
    Accounting.find(_id: req.params.id).remove ->
      res.send "#{req.params.id} deleted"
