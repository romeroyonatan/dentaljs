rewire = require 'rewire'
mongoose = require 'mongoose'
{Mock, spies} = require '../helpers/mongoose-mock'
controller = rewire '../../.app/controllers/accounting'
Accounting = require '../../.app/models/accounting'

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
    spyOn(Mock, "create")
    # Parameters
    accounting =
      date: new Date
      person: 'abc123'
      mount: 12
    req.body = accounting
    # Exec tests
    controller.create req, res
    expect(Mock.create).toHaveBeenCalledWith accounting, jasmine.any Function

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
    spyOn(Mock, 'remove')
    # Parameters
    req.params =
      id: 'abcxyz'
    # Exec tests
    controller.delete req, res
    expect(Mock.remove).toHaveBeenCalledWith _id: 'abcxyz',
                                             jasmine.any Function

describe 'Accounting controller tests without mock', ->

  beforeAll -> mongoose.connect 'mongodb://localhost/dentaljs-test', (err) ->
    console.error err if err

  afterEach ->
    Accounting.remove({})
    mongoose.disconnect()

  it 'father should has childs', (done) ->
    # preparing request mock
    req =
      body:
        description: "Child"
        assets: 1
    # preparing response mock
    res =
      status: ->
      send: (child) ->
        Accounting.findOne _id: child.parent, (err, parent)->
          expect(parent isnt null).toBe true
          if parent
            expect(parent.childs.length).toEqual 1
            expect(parent.childs[0]).toEqual child._id
          done()
    # create parent accounting
    Accounting.create description: "Father", debit: 10, (err, father) ->
      # create child accounting
      req.body.parent = father._id
      controller.create req, res
