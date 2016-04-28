# Person's Controller
# ----------------------
# This module implements CRUD methods for accounting's collection
mv = require 'mv'
fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
uuid = require 'node-uuid'
moment = require 'moment'
Person = require '../models/person'
Image = require '../models/image'
config = require '../config'

module.exports =
  # Obtains a list of persons
  list: (req, res, next) ->
    Person.find (err, list)->
      if err
        return next err
      res.send list

  # Creates a new person
  create: (req, res, next) ->
    object = new Person req.body
    object.save (err) ->
      if err
        return next err
      res.status 201
      res.send object

  # Updates data of a person
  update: (req, res, next) ->
    object = req.body
    Person.update slug: req.params.slug, object, (err, rawResponse) ->
      if err
        return next err
      if not rawResponse.ok
        return next status: 404, message: 'Person not found'
      res.send req.body

  # Get details of a person
  detail: (req, res, next) ->
    Person.findOne slug: req.params.slug, (err, object) ->
      # Error handling
      if err
        return next err
      if not object?
        return next status: 404, message: 'Person not found'
      res.send object

  # Remove a exiting person
  remove: (req, res, next) ->
    Person.findOne(slug: req.params.slug).remove ->
      res.status 204
      res.end()

  # uploadImage
  # -----------------
  # Upload image and associate its with person
  uploadImage: (req, res, next) ->
    # Get person
    Person.findOne slug: req.params.slug, (err, person)->
      # remove uploaded file if error
      fs.unlink req.files.file if err or not person?
      return next err if err
      # get uploaded file
      file = req.files.file
      # get file extension
      ext = path.extname file.path
      # make new path
      folder = req.params.slug + '/'
      mkdirp config.MEDIA_ROOT + folder, ->
        # generate filename based in timestamp
        # for example: `mick-jagger/2016-04-28_09:52:11.jpeg`
        # TODO Ojo con las colisiones
        filename = folder + moment().format 'Y-MM-DD_HH:mm:ss' + ext
        dest = config.MEDIA_ROOT + filename
        # move image to new folder
        mv file.path, dest, (err) ->
          return next err if err
          # asociate person with image
          Image.create person: person, path: filename, (err) ->
            return next err if err
            # send relative path of image
            res.status 201
            res.send config.MEDIA_PATH + filename

  # listImages
  # -----------------
  # Obtains the list of images associated with person
  listImages: (req, res, next) ->
    Image.find person: req.params.id
    .select '-person'
    # success
    .then (list)->
      # append media path to path
      object.path = config.MEDIA_PATH + object.path for object in list
      res.send list
    # error
    , (err)-> next err
