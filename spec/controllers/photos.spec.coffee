fs = require 'fs'
mkdirp = require 'mkdirp'
controller = require '../../.app/controllers/person'
Person = require  '../../.app/models/person'
Image = require  '../../.app/models/image'
config = require "../../.app/config"

describe "Image uploads tests", ->
  slug = "john-snow"
  req = params: {}
  res =
    status: ->
    send: ->

  rmdir = (path) ->
    files = fs.readdirSync path
    if  files.length > 0
      for file in files
        filepath = "#{path}/#{file}"
        if fs.statSync(filepath).isFile()
          fs.unlinkSync filepath
        else
          rmdir filepath
    fs.rmdirSync(path)

  # Prepare data for tests
  beforeEach (done) ->
    # create person
    Person.create first_name: 'John', last_name: 'Snow', ->
      mkdirp config.MEDIA_ROOT, done

  afterEach -> rmdir config.MEDIA_ROOT

  it 'should upload an image and place it into media folder', (done) ->
    # create an empty file
    filepath = config.MEDIA_ROOT + "test.jpg"
    fs.closeSync fs.openSync filepath, 'w'
    # prepare request
    req.params.slug = slug
    req.files =
      file:
        path: filepath
        headers: 'content-type': 'image/png'

    # prepare response and expects
    res.send = (data) ->
      filename = /.*\/(.*)$/.exec(data)[1]
      path = "#{config.MEDIA_ROOT}#{slug}/#{filename}"
      # check if file exists in filesystem
      expect(fs.statSync(path).isFile()).toBe true
      expect(fs.existsSync(filepath)).toBe false
      Image.findOne {}, (err, image)->
        # check if image's path attribute is correct
        expect(config.MEDIA_ROOT + image.path).toEqual path
        done()
    # call controller
    controller.uploadImage req, res

  it 'should upload a non image file', ->
  it 'should list images', ->
  it 'should remove an image', ->
  it 'should create an user´s folder', ->
  it 'should move image to an user´s folder', ->
  it 'should remove user´s folder and remove all images', ->
