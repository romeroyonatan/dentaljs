mongoose = require 'mongoose'
config = require "../../.app/config"

beforeAll (done) ->
  return done() if mongoose.connection.readyState is 1
  mongoose.connect config.MONGO_DB, (err) ->
    done.fail err if err
    done()

afterAll (done) -> mongoose.disconnect done

beforeEach ->
  for collection of mongoose.connection.collections
    mongoose.connection.collections[collection].remove {}
