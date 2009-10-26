
  require File.expand_path(File.dirname(__FILE__) + '/env.rb')
  require 'webrat/selenium'
  require 'selenium'
  require File.expand_path(File.dirname(__FILE__) + '/selenium_helpers.rb')


  Webrat.configure do |config|
    config.mode = :selenium
    config.application_environment = :test
  end

  After do
    Email.delete_all
    empty_database
  end
