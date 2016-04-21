###
# Create a mock class wich replaces Mongoose API
###
spies =
  ###
  These spies will be used to assert tests
  ###
  constructor: jasmine.createSpy()
  save: jasmine.createSpy()
  remove: jasmine.createSpy()
  update: jasmine.createSpy().and.returnValue (cb) -> cb()
  findOne: jasmine.createSpy()
  find: jasmine.createSpy()

Mock = (obj)->
  ###
  Mock constructor
  ###
  spies.constructor(obj)
  save: spies.save

Mock.find = (query, cb) ->
  ###
  Returns an object with remove attribute. Also call a callback function
  ###
  cb = query if query instanceof Function
  spies.find(query) if query instanceof Object
  cb? null, ['a', 'list']
  populate: -> exec: (cb) -> cb?(null, ['a', 'b', 'c'])

Mock.findOne = (filter, cb) ->
  ###
  Returns an object with remove attribute. Also call a callback function
  ###
  spies.findOne(filter)
  cb? null, {_id: 1234}
  remove: spies.remove

Mock.save = (cb) ->
  ###
  Call a callback function
  ###
  cb? null

Mock.update = (cb) ->
  ###
  Call a callback function
  ###
  cb? null

Mock.where = (cb) ->
  ###
  Return an object with a update function
  ###
  {update: spies.update}

Mock.create = (cb) ->
  ###
  Call a callback function
  ###
  cb? null

Mock.remove = (cb) ->
  ###
  Call a callback function
  ###
  cb? null

module.exports.Mock = Mock
module.exports.spies = spies
