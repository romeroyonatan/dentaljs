rewire = require 'rewire'
{Mock, spies} = require '../helpers/mongoose-mock'

describe 'Person´s controller tests', ->
  controller = rewire '../../.app/controllers/person'
  req = {}
  res = send: ->
  revert = null

  beforeEach ->
    # Configures mock
    revert = controller.__set__ "Person", Mock

  afterEach ->
    # Reverts mock
    revert?()

  it "Should list all persons", ->
    # Configure spy
    spyOn(res, 'send')
    # Exec tests
    controller.list req, res
    expect(res.send).toHaveBeenCalled()
    expect(res.send).toHaveBeenCalledWith ['a', 'list']

  it "Should create a person", ->
    # Parameters
    person =
      first_name: 'Example'
      last_name: 'Test'
    req.body = person
    # Exec tests
    controller.create req, res
    expect(spies.constructor).toHaveBeenCalledWith person
    expect(spies.save).toHaveBeenCalled()

  it "Should update a person", ->
    # Mock config
    spyOn(Mock, 'update').and.callThrough()
    # Parameters
    person =
      first_name: 'Example'
      last_name: 'Test'
    req.body = person
    req.params =
      slug: 'example-test'
    # Exec tests
    controller.update req, res
    expect(Mock.update).toHaveBeenCalledWith
      slug: 'example-test',
      person,
      jasmine.any(Function)

  it "Should retrieve details of a person", ->
    spyOn(res, 'send')
    # Parameters
    req.params =
      slug: 'example-test'
    # Exec tests
    controller.detail req, res
    expect(spies.findOne).toHaveBeenCalledWith slug: 'example-test'
    expect(res.send).toHaveBeenCalledWith jasmine.any Object

  it "Should delete a person", ->
    spyOn(res, 'send')
    # Parameters
    req.params =
      slug: 'example-test'
    # Exec tests
    controller.remove req, res
    expect(spies.findOne).toHaveBeenCalledWith slug: 'example-test'
    expect(spies.remove).toHaveBeenCalled()
