require File.expand_path(File.dirname(__FILE__) + '/mundo_pepino_env.rb')
require 'webrat/selenium'
require 'selenium'
require File.expand_path(File.dirname(__FILE__) + '/selenium_helpers.rb')

Cucumber::Rails::World.use_transactional_fixtures = false

Webrat.configure do |config|
  config.mode = :selenium
  config.application_environment = :test
end

World(Webrat::Selenium::Matchers)

Before do
  #Email.delete_all
  empty_database
end

After do
  #Email.delete_all
  empty_database
end