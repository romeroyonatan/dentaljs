describe 'Accounting controller tests', ->
  rewire = require 'rewire'
  mongoose = require 'mongoose'
  {Mock, spies} = require '../helpers/mongoose-mock'
  controller = rewire '../../.app/controllers/accounting'
  Accounting = require '../../.app/models/accounting'

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

  xdescribe 'Accounting controller tests without mock', ->

    _controller= require '../../.app/controllers/accounting'

    #beforeAll (done)->
    #  return done() if mongoose.connection.db?
    #  mongoose.connect 'mongodb://localhost/test', done
    #afterAll (done)-> mongoose.disconnect done

    beforeEach (done) -> Accounting.remove {}, done
    afterEach (done) -> Accounting.remove {}, done

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
            expect(parent.childs isnt null).toBe true
            expect(parent.childs.length).toEqual 1
            expect(parent.childs[0]).toEqual child._id
            done()
      # create parent accounting
      Accounting.create description: "Father", debit: 10, (err, father) ->
        # create child accounting
        console.assert not err?
        req.body.parent = father._id
        _controller.create req, res

    it 'should update father when child is removed', (done) ->
      # preparing request mock
      req = params: {}
      # preparing response mock
      res =
        status: ->
        send: (child) ->
          Accounting.findOne description: 'Father', (err, father)->
            expect(father?).toBe true
            expect(father.childs.length).toEqual 0
            done()
      # create parent accounting
      Accounting.create description: "Father", debit: 10, (err, father) ->
        # create child accounting
        Accounting.create description: "Child", credit: 10, (err, child) ->
          req.params.id = child._id
          _controller.delete req, res

    it 'should calculate a balance', (done) ->
      # Prepare mock request and response
      person = mongoose.Types.ObjectId '1234567890ab'
      req = params: person: person
      res = send: (data) ->
        expect(data.balance).toEqual -30
        done()
      # Create mock data
      Accounting.create [
        {description: "test1", debit: 10, person: person},
        {description: "test2", debit: 10, person: person},
        {description: "test3", debit: 10, person: person},
        {description: "test4", debit: 10, person: person},
        {description: "test5", debit: 10, person: person},
        {description: "test6", assets: 20, person: person},
      ], (err, list) ->
        _controller.balance req, res
