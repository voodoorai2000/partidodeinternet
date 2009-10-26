
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
  require 'cucumber/rails/world'
  require 'cucumber/formatter/unicode'
  #Cucumber::Rails.bypass_rescue

  require 'webrat'

  require 'cucumber/rails/rspec'
  require 'webrat/core/matchers'
  
  require 'spec/mocks'
  require 'ruby-debug'
  require 'chronic'
  require 'factory_girl'

  def empty_database
    connection = ActiveRecord::Base.connection
    connection.tables.each do |table|
      connection.execute "DELETE FROM #{table}" 
    end
  end
