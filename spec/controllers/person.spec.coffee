rewire = require 'rewire'
controller = rewire '../../.app/controllers/person'

describe 'Person´s controller tests', ->
  req = {}
  res = send: (msg)->

  beforeAll ->
    controller.__set__ "Person",
      find: (cb) -> cb null, ['a', 'list']
    spyOn(res, 'send')
    console.log "beforeAll called!"

  it "Should list all persons", ->
    controller.list req, res
    expect(res.send).toHaveBeenCalled()
    expect(res.send).toHaveBeenCalledWith(['a', 'list'])
