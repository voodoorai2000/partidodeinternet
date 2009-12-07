
 
#Change this:
PROJECT_NAME          = "iweekend"
AWS_ACCESS_KEY        = "123"
AWS_SECRET_ACCESS_KEY = "123"
HOAPTOAD_KEY          = "123"
STAGING_SERVER_IP     = "209.20.74.161"
PRODUCTION_SERVER_IP  = "209.20.74.161"

 
throw "The project's name in environment.rb is blank" if PROJECT_NAME.empty?
throw "Project name (#{PROJECT_NAME}) must_be_like_this" unless PROJECT_NAME =~ /^[a-z_]*$/
 
# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION
 
# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
 
Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
 
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.
 
  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
 
  # Specify gems that this application depends on.
    config.gem 'rspec', 
               :lib      => false, 
               :version  => ">=1.2.2"
    
    config.gem 'rspec-rails', 
               :lib      => false, 
               :version  => ">=1.2.2"
    
    config.gem 'webrat', 
               :lib      => false, 
               :version  => ">=0.4.4"
    
    config.gem 'cucumber', 
               :lib      => false, 
               :version  => ">=0.3"
    
    config.gem 'chronic'
    
    config.gem 'hpricot', 
               :source   => 'http://code.whytheluckystiff.net'
    
    config.gem 'tpope-pickler',
                :lib     => 'pickler',
                :source  => 'http://gems.github.com'
                 
    #config.gem 'sqlite3-ruby', 
    #           :lib     => 'sqlite3',
    #           :version => '>=1.2.4'
    
    config.gem 'aws-s3', 
               :lib      => 'aws/s3'
               
    config.gem 'RedCloth',
               :lib      => 'redcloth', 
               :version  => '~> 3.0.4'
    
    config.gem 'mislav-will_paginate', 
               :lib      => 'will_paginate', 
               :source   => 'http://gems.github.com', 
               :version  => '~> 2.3.5'
    
    config.gem 'mocha', 
               :version  => '>= 0.9.2'
    
    config.gem 'quietbacktrace', 
               :version  => '>= 0.1.1'
    
   config.gem  'thoughtbot-factory_girl',
               :lib    => false,
               :source => "http://gems.github.com"
   #config.gem  'jscruggs-metric_fu',
   #            :lib => 'metric_fu'

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  
  # Add the vendor/gems/*/lib directories to the LOAD_PATH
  config.load_paths += Dir.glob(File.join(RAILS_ROOT, 'vendor', 'gems', '*', 'lib'))
  
  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug
 
  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'UTC'
 
  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  SESSION_KEY = "CHANGESESSION" 
  config.action_controller.session = {
    :session_key => "_#{PROJECT_NAME}_session",
    :secret      => SESSION_KEY
  }
 
  config.active_record.observers = :user_observer
  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store
 
  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql
 
  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.i18n.default_locale = :es
end
