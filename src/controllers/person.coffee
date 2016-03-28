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
    Person.where(slug: req.params.slug).update object, ->
      res.send object

  detail: (req, res) ->
    console.log req.params
    Person.findOne slug: req.params.slug, (err, object) ->
      res.send object

  delete: (req, res) ->
    Person.find(slug: req.params.slug).remove ->
      res.send "#{req.params.slug} deleted"
