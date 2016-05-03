xdescribe 'Odontogram controller tests', ->
  mongoose = require 'mongoose'
  controller = require '../../.app/controllers/odontogram'
  Odontogram = require '../../.app/models/odontogram'
  Issue = require '../../.app/models/issue'
  db = null

  beforeEach ->
    db = mongoose.createConnection 'mongodb://localhost/test'
    db.on 'error', (err) -> console.error err
    db.once 'open', done
  afterEach (done) -> db.disconnect done

  fix = {}
  disease = {}

  # prepare database
  beforeEach (done)->
    Odontogram.remove {}
    .then ->
      console.log db
      Issue.create(code:'a', type: 1, description: "Disease").then (object) ->
        disease = object
        console.log object
    .then ->
      Issue.create(code:'x', type: 2, description: "Fix").then (object) ->
        fix = object
        console.log object
    .then done
    .catch (err) ->
      console.error err
      done
    .exec()

  # clean database
  afterEach (done) ->
    Odontogram.remove {}
              .then -> Issue.remove {}
              .then -> done()
              .catch (err) -> console.error err

  odontogram =
    title: "Test"
    comment: "Test odontogram"
    pieces: [
      {id: 11, sectors: [id: 0, issue: disease._id]},
      {id: 38, sectors: [id: 2, issue: fix._id]},
    ]


  it 'should create new odontogram', (done) ->
    # preparing request mock
    req = body: odontogram
    # preparing response mock
    res =
      status: ->
      send: (object) ->
        console.log object
        Odontogram.findOne _id: object._id, (err, odontogram) ->
          expect(odontogram.title).toEqual "Test"
          expect(odontogram.comment).toEqual "Test odontogram"
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
    controller.create req, res

  it 'should list odontogram', (done) ->
    Odontogram.create odontogram
    .then ->
      # preparing response mock
      res =
        status: ->
        send: (list) ->
          expect(list.length).toEqual 1
          expect(list[0].title).toEqual "Test"
          expect(list[0].comment).toEqual "Test odontogram"
          done()
      # create Odontogram
      controller.list {}, res

  it 'should show detailf of an odontogram', (done) ->
    Odontogram.create(odontogram).then (odontogram) ->
      # preparing request mock
      req = params: id: odontogram._id
      # preparing response mock
      res =
        status: ->
        send: (object) ->
          expect(object isnt null).toBe true
          expect(object.title).toEqual "Title"
          expect(object.comment).toEqual "Title odontogram"
          expect(object.pieces.length).toEqual 2
          expect(object.pieces[0].id).toEqual 11
          expect(object.pieces[0].sectors.length).toEqual 1
          expect(object.pieces[0].sectors[0].id).toEqual 0
          expect(object.pieces[0].sectors[0].issue).toEqual disease._id
          expect(object.pieces[1].id).toEqual 38
          expect(object.pieces[1].sectors.length).toEqual 1
          expect(object.pieces[1].sectors[0].id).toEqual 2
          expect(object.pieces[1].sectors[0].issue).toEqual fix._id
          done()

      # create Odontogram
      controller.create req, res
