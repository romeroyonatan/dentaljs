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
      Folder.findOne person: person, _id: req.params.folderId
      .then (folder) ->
        # if folder not found
        if req.params.foldernId? and not folder?
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
      Folder.findOne person: person, name: req.params.foldername
      .then (folder) ->
        # Folder doesnt exists
        if req.params.foldername and not folder?
          return next status: 404, message: "Folder not found"
        filter =
          person: person
          folder: folder if folder?
        Image.find filter
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
    Image.findByIdAndRemove req.params.id, (err, image) ->
      return next err if err
      fs.unlink config.MEDIA_ROOT + image.path, (err) ->
        return next err if err
        res.status 204
        res.end()

  # update
  # --------------------------------------------------------------------------
  # update an exiting image
  update: (req, res, next) ->
    # preparing for update
    object =
      folder: req.body.folder
      description: req.body.description
    # get folder object
    Folder.findById object.folder, (err, folder) ->
      # error handle
      return next err if err
      if object.folder and not folder?
        return next status: 404, message: "Folder not found"
      # update image
      Image.findByIdAndUpdate req.params.id, object
      .populate('person')
      .then (image) ->
        # error handle
        return next status: 404, message: "Image not found" if not image?
        # if folder change, move file in filesystem
        if object.folder isnt image.folder
          # update the image's path in filesystem
          filename = /\/?(.*)$/.exec(image.path)[1]
          relative_path = image.person.slug + "/"
          relative_path += folder.name + "/" if folder?
          absolute_path = config.MEDIA_ROOT + relative_path + filename
          mkdirp config.MEDIA_ROOT + relative_path, (err) ->
            return next err if err
            mv config.MEDIA_ROOT + image.path, absolute_path, (err) ->
              return next err if err
              # save the new path
              image.path = relative_path + filename
              image.save (err)->
                # send updated image
                return next err if err
                res.status 200
                res.send image
        else
          res.status 200
          res.send image
      # error handle
      , (err) -> return next err
