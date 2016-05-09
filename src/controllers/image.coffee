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
Folder = require '../models/folder'
config = require '../config'

module.exports =
  # validate
  # --------------------------------------------------------------------------
  # Validate upload file
  validate: (req, res, next) ->
    # Get person
    Person.findOne slug: req.params.slug, (err, person)->
      # get uploaded file
      file = req.files.file
      is_image = /^image\/.*/.test file.headers['content-type']
      # remove uploaded file if error
      if err
        fs.unlink file.path, ->
          return next err
      # validate if persons exists
      else if not person?
        fs.unlink file.path, ->
          next status: 404, message: "Person not found"
      # validate file type
      else if not is_image
        fs.unlink file.path, ->
          next status: 400, message: "Invalid filetype"
      else
        next()

  # create
  # --------------------------------------------------------------------------
  # Upload image and associate its with person
  create: (req, res, next) ->
    # Get person
    Person.findOne slug: req.params.slug
    .then (person) ->
      # if person not found
      return next status: 404, message: "Person not found" if not person?
      # Get folder
      Folder.findOne person: person, name: req.params.foldername
      .then (folder) ->
        # if folder not found
        if req.params.foldername? and not folder?
          return next status: 404, message: "Folder not found"
        # get uploaded file's path
        file = req.files.file
        # get file extension
        ext = path.extname file.path
        # make new path
        dir = req.params.slug + "/"
        dir += folder.name + "/" if folder?
        mkdirp config.MEDIA_ROOT + dir, ->
          # generate filename based in timestamp
          # for example: `mick-jagger/2016-04-28_09:52:11:123.jpeg`
          filename = dir + moment().format 'Y-MM-DD_HH:mm:ss:SSS' + ext
          dest = config.MEDIA_ROOT + filename
          # move image to new folder
          mv file.path, dest, (err) ->
            return next err if err
            # asociate person with image
            image = new Image
              person: person
              path: filename
              folder: folder if folder?
            image.save().then ->
              # send relative path of image
              res.status 201
              res.send config.MEDIA_PATH + filename
    , (err) -> next err

  # list
  # --------------------------------------------------------------------------
  # Obtains the list of images associated with person
  list: (req, res, next) ->
    Person.findOne slug: req.params.slug, (err, person) ->
      # handle errors
      return next err if err
      return next {status: 404, message: "Not found"} if not person?
      Image.find person: person._id
      # remove person from list
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
  # Remove an exiting image
  remove: (req, res, next) ->
    Image.remove _id: req.params.id
    # success
    .then (image) ->
      fs.unlink image.path, ->
        res.status 204
        res.end()
    # error
    , (err) -> next err

  # update
  # --------------------------------------------------------------------------
  # update an exiting image
  update: (req, res, next) ->
    delete req.body._id
    Image.findByIdAndUpdate req.params.id, req.body, new: true
    .populate('person folder')
    # success
    .then (image) ->
      if image.folder?
        # update the image's path in filesystem
        filename = /.*\/(.*)$/.exec(image.path)[1]
        dir = "#{image.person.slug}/#{image.folder.name}/"
        dest = config.MEDIA_ROOT + dir + filename
        mkdirp config.MEDIA_ROOT + dir, ->
          mv image.path, dest, (err) ->
            return next err if err
            # save the new path
            image.path = dir + filename
            image.save (err)->
              # send updated image
              return next err if err
              res.status 204
              res.send(image)
      else
        res.status 204
        res.send(image)
    # error
    , (err) -> next err
