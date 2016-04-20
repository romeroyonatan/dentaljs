rewire = require 'rewire'
{Mock, spies} = require '../helpers/mongoose-mock'
controller = rewire '../../.app/controllers/accounting'

describe 'Accounting controller tests', ->
  req = {}
  res = send: ->
  revert = null

  beforeEach ->
    # Configures mock
    revert = controller.__set__ "Accounting", Mock

  afterEach ->
    # Reverts mock
    revert?()

  it "Should list all accountings", ->
    # Configure spy
    req.query =
      person: 'abc123'
    spyOn(res, 'send')
    # Exec tests
    controller.list req, res
    expect(res.send).toHaveBeenCalled()
    expect(res.send).toHaveBeenCalledWith jasmine.any Array

  it "Should create an accounting", ->
    # Parameters
    accounting =
      date: new Date
      person: 'abc123'
      mount: 12
    req.body = accounting
    # Exec tests
    controller.create req, res
    expect(spies.constructor).toHaveBeenCalledWith accounting
    expect(spies.save).toHaveBeenCalled()

  it "Should update an accounting", ->
    # Mock config
    spyOn(Mock, 'update').and.callThrough()
    # Parameters
    accounting =
      date: new Date
      person: 'abc123'
      mount: 12
    req.body = accounting
    req.params =
      id: 'abcxyz'
    # Exec tests
    controller.update req, res
    expect(Mock.update).toHaveBeenCalledWith _id:'abcxyz', accounting,
                                             jasmine.any Function

  it "Should retrieve details of an accounting", ->
    spyOn(res, 'send')
    # Parameters
    req.params =
      id: 'abcxyz'
    # Exec tests
    controller.detail req, res
    expect(spies.findOne).toHaveBeenCalledWith _id: 'abcxyz'
    expect(res.send).toHaveBeenCalledWith jasmine.any Object

  it "Should delete an accounting", ->
    spyOn(res, 'send')
    # Parameters
    req.params =
      id: 'abcxyz'
    # Exec tests
    controller.delete req, res
    expect(spies.findOne).toHaveBeenCalledWith _id: 'abcxyz'
    expect(spies.remove).toHaveBeenCalled()
