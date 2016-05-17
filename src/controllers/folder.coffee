# Folder's Controller
# ----------------------
# This module implements CRUD methods for folder's collection
fs = require 'fs'
Person = require '../models/person'
Folder = require '../models/folder'
Image = require '../models/image'
config = require '../config'
rmdir = require('./helpers').rmdir

module.exports =
  # list
  # --------------------------------------------------------------------------
  # Obtains a list of folders
  list: (req, res, next) ->
    Person.findOne slug: req.params.slug, (err, person) ->
      return next err if err
      return next status: 404, message: "Not found" if not person?
      Folder.find person: person._id, (err, list)->
        return next err if err
        res.send list

  # create
  # --------------------------------------------------------------------------
  # Creates a new folder
  create: (req, res, next) ->
    Person.findOne slug: req.params.slug, (err, person) ->
      return next err if err
      return next status: 404, message: "Not found" if not person?
      req.body.person = person
      Folder.count person: person, name: req.body.name
      .then (count) ->
        if count is 0
          Folder.create req.body, (err, object) ->
            return next err if err
            res.status 201
            res.send object
        else
          return next status: 400, message: "Folder exists"

  # update
  # --------------------------------------------------------------------------
  # Updates data of a folder
  update: (req, res, next) ->
    Folder.findById req.params.id, (err, old) ->
      # folder not found
      return next status: 404, message: 'Not found' if not old?
      changeName = old.name != req.body.name
      Folder.findOne person: old.person, name: req.body.name, (err, exists) ->
        # if change name verify if folder doesnt exists
        if exists? and changeName
          return next status: 400, message: "Folder name already exists"
        # update object
        Folder.findByIdAndUpdate req.params.id, req.body, new: true,
        (err, _new) ->
          res.send _new

  # detail
  # --------------------------------------------------------------------------
  # Get details of a folder
  detail: (req, res, next) ->
    Person.findOne slug: req.params.slug, (err, person)->
      # Error handling
      return next err if err
      return next status: 404, message: 'Person not found' if not person?
      # Search folder
      Folder.findOne name: req.params.name, person: person, (err, folder) ->
        # Error handling
        return next err if err
        return next status: 404, message: 'Folder not found' if not folder?
        # get childs
        folder.childs = []
        # find for images
        Image.find(folder: folder._id).then (images) ->
          folder.childs = folder.childs.concat images
          res.send folder

  # remove
  # --------------------------------------------------------------------------
  # Remove a exiting folder and its childs
  remove: (req, res, next) ->
    Folder.findOneAndRemove _id: req.params.id
    .populate("person")
    .then (folder) ->
      return next status: 404, message: 'Not found' if not folder?
      # Remove folder in filesystem
      path = config.MEDIA_ROOT + folder.person.slug + "/" + folder.name
      rmdir path, (err) ->
        # Remove images associated with folder
        Image.remove(folder: folder).then (images) ->
          res.status 204
          res.end()
    , (err) -> return next err
