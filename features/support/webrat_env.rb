
require File.expand_path(File.dirname(__FILE__) + '/env.rb')
require File.expand_path(File.dirname(__FILE__) + '/webrat_helpers.rb')
require 'webrat/rails'

#Cucumber::Rails.use_transactional_fixtures

Webrat.configure do |config|
  config.mode = :rails
end

After do
  empty_database
end
