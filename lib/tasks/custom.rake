require(File.join Rails.root, 'config', 'environment')

namespace :features do
  desc "Run all features"
  task :all => [ :db, :webrat, :selenium ]
  
  desc "Prepare test database"
  task :db do
    Rake::Task['db:test:prepare'].invoke
  end
  
  desc "Run webrat features"
  task :webrat do
    sh "script/cucumber --profile webrat"
  end
  
  desc "Run selenium features"
  task :selenium do
    sh "script/cucumber --profile selenium"
  end
  
end

namespace :admin do
  desc "create an admin user"
  task :create do
    user = User.create!(:admin => true, 
                 :email => "admin@partidodeinternet.es", 
                 :password => "testtest",
                 :password_confirmation => "testtest")
    user.activate!
    user.admin = true
    user.save!
  end
end