mongoose = require 'mongoose'

clearDB = (cb) ->
  for collection in mongoose.connection.collections
    collection.remove {}, cb

beforeEach (done) ->
  return done() if mongoose.connection.readyState is 1
  mongoose.connect 'mongodb://localhost/test', (err) ->
    done.fail err if err
    clearDB done

afterEach (done) -> mongoose.disconnect done
