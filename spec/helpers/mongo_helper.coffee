mongoose = require 'mongoose'

beforeAll (done) ->
  return done() if mongoose.connection.readyState is 1
  mongoose.connect 'mongodb://localhost/test', (err) ->
    done.fail err if err
    done()

afterAll (done) -> mongoose.disconnect done

beforeEach ->
  for collection of mongoose.connection.collections
    mongoose.connection.collections[collection].remove {}
