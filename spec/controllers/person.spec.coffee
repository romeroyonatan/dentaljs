rewire = require 'rewire'
controller = rewire '../../.app/controllers/person'

xdescribe 'Person´s controller tests', ->
  req = {}
  res = send: (msg)->

  beforeAll ->
    controller.__set__ "Person",
      find: (cb) ->
        console.log "Find called!"
        cb null, ['a', 'list']
    spyOn(res, 'send')

  it "Should list all persons", ->
    controller.list req, res
    expect(res.send).toHaveBeenCalled()
    expect(res.send).toHaveBeenCalledWith(['a', 'list'])
