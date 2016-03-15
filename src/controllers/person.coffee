Person = require '../models/person'

module.exports =

  list: (req, res) ->
    Person.find (err, list)->
      res.send list

  create: (req, res) ->
    object = req.body
    console.log "Creating object #{JSON.stringify object}"
    # TODO validate data
    object = new Person object
    object.save (err) ->
      if not err
        res.send object

  update: (req, res) ->
    object = req.body
    console.log "Updating object #{JSON.stringify object}"
    # TODO validate data
    Person.where(_id: req.params.id).update object, ->
      res.send object

  detail: (req, res) ->
    Person.findOne _id: req.params.id, (err, object)->
      res.send object

  delete: (req, res) ->
    Person.find(_id: req.params.id).remove ->
      res.send "#{req.params.id} deleted"
