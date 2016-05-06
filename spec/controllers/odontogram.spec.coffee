mongoose = require 'mongoose'
controller = require '../../.app/controllers/odontogram'
Odontogram = require '../../.app/models/odontogram'
Issue = require '../../.app/models/issue'

describe 'Odontogram controller tests', ->
  fix = {}
  disease = {}
  odontogram = {}

  # prepare database
  beforeEach (done) ->
    Odontogram.remove {}, ->
      Issue.create code:'a', type: 1, description: "Disease", (err, object) ->
        disease = object
        Issue.create code:'x', type: 2, description: "Fix", (err, object) ->
          fix = object
          odontogram =
            title: "Test"
            comments: "Test odontogram"
            pieces: [
              {id: 11, sectors: [id: 0, issue: disease._id]},
              {id: 38, sectors: [id: 2, issue: fix._id]},
            ]
          done()

  # clean database
  afterEach (done) ->
    Odontogram.remove {}, -> Issue.remove {}, done


  it 'should create new odontogram', (done) ->
    # preparing request mock
    req = body: odontogram
    # preparing response mock
    res =
      status: ->
      send: (object) ->
        Odontogram.findOne _id: object._id, (err, odontogram) ->
          expect(odontogram.title).toEqual "Test"
          expect(odontogram.comments).toEqual "Test odontogram"
          expect(odontogram.pieces.length).toEqual 2
          expect(odontogram.pieces[0].id).toEqual 11
          expect(odontogram.pieces[1].id).toEqual 38
          expect(odontogram.pieces[0].sectors.length).toEqual 1
          expect(odontogram.pieces[1].sectors.length).toEqual 1
          expect(odontogram.pieces[0].sectors[0].id).toEqual 0
          expect(odontogram.pieces[1].sectors[0].id).toEqual 2
          expect(odontogram.pieces[0].sectors[0].issue).toEqual disease._id
          expect(odontogram.pieces[1].sectors[0].issue).toEqual fix._id
          done()
    # create Odontogram
    controller.create req, res, (err) -> console.error err

  it 'should list odontogram', (done) ->
    Odontogram.create odontogram
    .then ->
      # preparing response mock
      res =
        status: ->
        send: (list) ->
          expect(list.length).toEqual 1
          expect(list[0].title).toEqual "Test"
          expect(list[0].comments).toEqual "Test odontogram"
          done()
      controller.list {}, res

  it 'should show detail of an odontogram', (done) ->
    Odontogram.create odontogram, (err, odontogram) ->
      # preparing request mock
      req = params: id: odontogram._id
      # preparing response mock
      res =
        status: ->
        send: (object) ->
          expect(object isnt null).toBe true
          expect(object.title).toEqual "Test"
          expect(object.comments).toEqual "Test odontogram"
          expect(object.pieces.length).toEqual 2
          expect(object.pieces[0].id).toEqual 11
          expect(object.pieces[0].sectors.length).toEqual 1
          expect(object.pieces[0].sectors[0].id).toEqual 0
          expect(object.pieces[0].sectors[0].issue._id).toEqual disease._id
          expect(object.pieces[1].id).toEqual 38
          expect(object.pieces[1].sectors.length).toEqual 1
          expect(object.pieces[1].sectors[0].id).toEqual 2
          expect(object.pieces[1].sectors[0].issue._id).toEqual fix._id
          done()
      controller.detail req, res, (err) -> console.error err
