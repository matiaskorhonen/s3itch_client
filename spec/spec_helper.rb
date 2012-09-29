require "simplecov"
SimpleCov.start

require "bundler"
  
Bundler.setup

require "rspec"
require "webmock/rspec"
require "s3itch_client"
