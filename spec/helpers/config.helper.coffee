# Load testing parameters from config file
config = require "../../.app/config"

beforeAll ->
  config.setEnvironment 'testing'
