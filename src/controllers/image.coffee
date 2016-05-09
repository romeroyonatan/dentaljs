# Image's Controller
# ----------------------
# This module implements methods for image's collection
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

  # create
  # --------------------------------------------------------------------------
  # Upload image and associate its with person
  create: (req, res, next) ->
    # Get person
    Person.findOne slug: req.params.slug, (err, person)->
      # get uploaded file
      file = req.files.file
      is_image = /^image\/.*/.test file.headers['content-type']
      # remove uploaded file if error
      if err
        fs.unlink file.path
        return next err
      # validate if persons exists
      if not person?
        fs.unlink file.path
        return next status: 404, message: "Person not found"
      # validate file type
      if not is_image
        fs.unlink file.path
        return next status: 400, message: "Invalid filetype"
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

  # list
  # --------------------------------------------------------------------------
  # Obtains the list of images associated with person
  list: (req, res, next) ->
    Image.find person: req.params.id
    .select '-person'
    # success
    .then (list)->
      # append media path to path
      object.path = config.MEDIA_PATH + object.path for object in list
      res.send list
    # error
    , (err)-> next err

  # remove
  # --------------------------------------------------------------------------
  # Remove a exiting person
  remove: (req, res, next) ->
    Person.findOne(slug: req.params.slug).remove ->
      res.status 204
      res.end()
