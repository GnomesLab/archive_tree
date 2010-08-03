$:.unshift File.dirname(__FILE__) unless $:.include? File.dirname(__FILE__)
require 'rspec'
require 'archive_tree'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.debug = true
  # == Mock Framework
  config.mock_with :rspec
end