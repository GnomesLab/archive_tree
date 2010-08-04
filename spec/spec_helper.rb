$:.unshift File.dirname(__FILE__) unless $:.include? File.dirname(__FILE__)

begin
  require 'logger'
  require 'rspec'
  require 'database_cleaner'
  require 'archive_tree'

  RSpec.configure do |config|
    config.debug = true
    # == Mock Framework
    config.mock_with :rspec

    # database_cleaner
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
rescue LoadError => load_error
  puts "Please run bundle install"
rescue StandardError => e
  puts "Something went wrong while loading the environment."
  throw e
end

# Requires supporting files with custom matchers and macros, etc, in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# ActiveRecord Test database configurations
database_yml_file = File.expand_path('../config/database.yml', __FILE__)

begin
  if File.exists?(database_yml_file)
    active_record_configuration = YAML.load_file(database_yml_file)["test"]

    ActiveRecord::Base.establish_connection(active_record_configuration)
    ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), 'log', 'test.log'))

    ActiveRecord::Base.silence do
      ActiveRecord::Migration.verbose = false

      load File.join(File.dirname(__FILE__), 'db', 'schema.rb')
      load File.join(File.dirname(__FILE__), 'db' , 'models.rb')
    end
  else
    raise "Please create #{database_yml} first. Take a look at the database.sample.yml in the config folder."
  end
rescue StandardError => e
  puts "Something went wrong while attempting to load your database file, or while configuring ActiveRecord."
  throw e
end
