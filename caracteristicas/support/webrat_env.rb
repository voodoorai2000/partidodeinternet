require File.expand_path(File.dirname(__FILE__) + '/mundo_pepino_env.rb')

Cucumber::Rails::World.use_transactional_fixtures = true

Webrat.configure do |config|
  config.mode = :rails
end