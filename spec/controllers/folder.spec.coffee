controller = require '../../.app/controllers/folder'
Person = require  '../../.app/models/person'
Folder = require  '../../.app/models/folder'

describe "Folder tests", ->
  person = null
  req = params: {}
  res =
    status: ->
    send: ->

  # Prepare data for tests
  beforeEach (done) ->
    # create person
    Person.create first_name: 'John', last_name: 'Snow', (err, obj)->
      person = obj
      done()

  it 'should create an user´s folder', (done)->
    # prepare request
    req.body = name: "folder"
    req.params.slug = person.slug
    # prepare expects
    res.send = (data) ->
      expect(data.name).toEqual "folder"
      Folder.findOne _id: data._id, (err, folder)->
        console.err err if err
        expect(folder?).toBe true
        done()
    # call controller
    controller.create req, res, (err) -> done.fail err

  it 'should fail when name contains illegal characters', (done)->
    # prepare request
    req.body = name: "../../folder"
    req.params.slug = person.slug
    # call controller
    controller.create req, res, (err) ->
      expect(err.name).toEqual "ValidationError"
      done()

  it 'should list folders', (done)->
    # create folders
    folders = [
      {person: person, name:"test1"}
      {person: person, name:"test2"}
      {person: person, name:"test3"}
      {person: person, name:"test4"}
      {person: '12345678901', name:"test5"}
    ]
    Folder.create folders, ->
      # prepare request
      req.params.slug = person.slug
      # prepare expects
      res.send = (data) ->
        expect(data.length).toEqual 4
        data = JSON.stringify data
        # check all folders is included
        expect(data.indexOf 'test1').toBeGreaterThan 0
        expect(data.indexOf 'test2').toBeGreaterThan 0
        expect(data.indexOf 'test3').toBeGreaterThan 0
        expect(data.indexOf 'test4').toBeGreaterThan 0
        expect(data.indexOf 'test5').toEqual -1
        done()
      # call controller
      controller.list req, res, (err) -> done.fail err

  it 'should update folders', (done)->
    # create folder
    Folder.create person: person, name: "foo", (err, folder)->
      # prepare request
      req.params.id = folder._id
      req.body.name = 'bar'
      # prepare expects
      res.send = (data) ->
        expect(data.name).toEqual 'bar'
        done()
      # call controller
      controller.update req, res, (err) -> done.fail err

  xit 'should remove a folder', (done)->
    # create folder
    Folder.create person: person, name: "foo", (err, folder)->
      # prepare request
      req.params.id = folder._id
      # prepare expects
      res.end = ->
        Folder.findOne _id: folder._id, (err, object)->
          expect(object?).toBe false
          done()
      # call controller
      controller.remove req, res, (err) -> done.fail err

  it 'should display folder´s details', (done)->
    # create folder
    Folder.create person: person, name: 'foo', (err, folder)->
      # prepare request
      req.params.slug = person.slug
      req.params.name = 'foo'
      # prepare expects
      res.send = (data) ->
        expect(data.created?).toBe true
        expect(data.person?).toBe true
        expect(data.name).toEqual 'foo'
        expect(data.childs.length).toEqual 0
        done()
      # call controller
      controller.detail req, res, (err) -> done.fail err
