describe 'email utils tests', ->
  rewire = require 'rewire'
  Accounting = require '../../.app/models/accounting'
  Person = require '../../.app/models/accounting'
  email = rewire '../../.app/utils/email'

  # prepare mock of emailjs
  mock_server = send: ->
  mock_connect = server: connect: -> mock_server
  revert = null

  # patch emailjs module
  beforeEach ->
    revert = email.__set__ 'email', mock_connect
    spyOn mock_server, 'send'

  afterEach -> revert()

  it 'should not send email if person hasnt email', (done) ->
    Person.create name: 'foo', (err, person)->
      done err if err
      email.send_current_account person._id, ->
        expect(mock_server.send).not.toHaveBeenCalled()
        done()

  it 'should dont send email if person doesnt exists', (done) ->
    email.send_current_account 'inexistent______________', (sended) ->
      expect(mock_server.send).not.toHaveBeenCalled()
      expect(sended).toBeDefined()
      done()

  it 'should send email if person has email', (done) ->
    Person.create name: 'foo', email:'email@example.com', (err, person)->
      done err if err
      console.log person._id
      email.send_current_account person._id, (err) ->
        return done err if err
        expect(mock_server.send).toHaveBeenCalled()
        done()
