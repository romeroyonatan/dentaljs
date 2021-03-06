fs = require 'fs'
mkdirp = require 'mkdirp'
controller = require '../../.app/controllers/image'
Person = require  '../../.app/models/person'
Image = require  '../../.app/models/image'
Folder = require  '../../.app/models/folder'
config = require "../../.app/config"

describe "Image uploads tests", ->
  person = null
  slug = null
  req = params: {}
  res =
    status: ->
    send: ->

  # rmdir
  # ======
  # Remove dir and files recursevely
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
    Person.create first_name: 'John', last_name: 'Snow', (err, obj)->
      mkdirp config.MEDIA_ROOT, done
      person = obj
      slug = obj.slug

  # remove created files
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
      # extract filename from path returned into data
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
    controller.create req, res, (err) -> done.fail err

  it 'should upload a non image file', (done) ->
    # create an empty file
    filepath = config.MEDIA_ROOT + "test.jpg"
    fs.closeSync fs.openSync filepath, 'w'
    # prepare request
    req.params.slug = slug
    req.files =
      file:
        path: filepath
        headers: 'content-type': 'application/javascript'

    # call controller
    controller.validate req, res, (err) ->
      # check error
      expect(err.status).toEqual 400
      expect(fs.existsSync(filepath)).toBe false
      done()

  it 'should upload to inexistent person', (done) ->
    # create an empty file
    filepath = config.MEDIA_ROOT + "test.jpg"
    fs.closeSync fs.openSync filepath, 'w'
    # prepare request
    req.params.slug = 'foo'
    req.files =
      file:
        path: filepath
        headers: 'content-type': 'image/jpeg'

    # call controller
    controller.validate req, res, (err) ->
      # check error
      expect(err.status).toEqual 404
      expect(fs.existsSync(filepath)).toBe false
      done()

  it 'should list images', (done)->
    # create a image's list
    images = [
      {person: person, path: 'test1.jpg'},
      {person: person, path: 'test2.jpg'},
      {person: person, path: 'test3.jpg'},
      {person: person, path: 'test4.jpg'},
      {path: 'test5.jpg'},
    ]
    Image.create images, ->
      # prepare request
      req.params.slug = slug
      # prepare expects
      res.send = (data) ->
        # convert data to string
        data = JSON.stringify data
        # check for files
        expect(data.indexOf 'test1.jpg').toBeGreaterThan 0
        expect(data.indexOf 'test2.jpg').toBeGreaterThan 0
        expect(data.indexOf 'test3.jpg').toBeGreaterThan 0
        expect(data.indexOf 'test4.jpg').toBeGreaterThan 0
        expect(data.indexOf 'test5.jpg').toEqual -1
        done()
      # call controller
      controller.list req, res, (err) -> done.fail err

  it 'should remove an image', (done)->
    # create empty file
    filepath = config.MEDIA_ROOT + "test.jpg"
    fs.closeSync fs.openSync filepath, 'w'
    # create image
    Image.create person: person, path: "test.jpg", (err, image)->
      # prepare request
      req.params.id = image._id
      # prepare expects
      res.end = () ->
        expect(fs.existsSync(filepath)).toBe false
        Image.findById image._id, (err, image) ->
          expect(image?).toBe false
        done()
      # call controller
      controller.remove req, res, (err) -> done.fail err

  it 'should move image to an user´s folder', (done)->
    # create empty file
    filepath = config.MEDIA_ROOT + "test.jpg"
    fs.closeSync fs.openSync filepath, 'w'
    # create image
    Image.create person: person, path: "test.jpg", (err, image)->
      # create folder
      Folder.create person: person, name: 'foo', (err, folder)->
        # prepare request
        req.params.id = image._id
        req.body = image
        req.body.folder = folder._id
        # prepare expects
        res.send = (data) ->
          Image.findOne _id = data._id, (err, image) ->
            return done.fail err if err
            expect(image.folder).toEqual folder._id
            expect(image.path.indexOf 'foo').toBeGreaterThan 0
            expect(fs.existsSync(filepath)).toBe false
            expect(fs.existsSync(config.MEDIA_ROOT + image.path)).toBe true
            done()
        # call controller
        controller.update req, res, (err) -> done.fail err

  it 'should upload an image into folder', (done)->
    # create an empty file
    filepath = config.MEDIA_ROOT + "test.jpg"
    fs.closeSync fs.openSync filepath, 'w'
    # create folder
    Folder.create person: person, name: 'foo', (err, folder) ->
      # prepare request
      req.params =
        slug: person.slug
        folderId: folder._id
      req.files = file: path: filepath
      # prepare response and expects
      res.send = (data) ->
        # extract filename from path returned into data
        filename = /.*\/(.*)$/.exec(data)[1]
        path = "#{config.MEDIA_ROOT}#{slug}/foo/#{filename}"
        # check if file exists in filesystem
        expect(fs.statSync(path).isFile()).toBe true
        expect(fs.existsSync(filepath)).toBe false
        Image.findOne {}, (err, image) ->
          # check if image's path attribute is correct
          expect(config.MEDIA_ROOT + image.path).toEqual path
          expect(image.folder).toEqual folder._id
          done()
      # call controller
      controller.create req, res, (err) -> done.fail err

  it 'should remove user´s folder and remove all images inside it', (done)->
    controller = require '../../.app/controllers/folder'
    # create an empty file
    filepath = config.MEDIA_ROOT + "test.jpg"
    fs.closeSync fs.openSync filepath, 'w'
    # create folder
    Folder.create person: person, name: 'foo', (err, folder) ->
      # create image
      Image.create person:person, path:filepath, folder:folder, (err, image)->
        # prepare request
        req.params.id = folder._id
        # prepare response and expects
        res.end = ->
          # check if file exists in filesystem
          Image.findOne {}, (err, image) ->
            # check if image's path attribute is correct
            expect(image?).toBe false
            done()
        # call controller
        controller.remove req, res, (err) -> done.fail err
