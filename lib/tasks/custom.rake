
namespace :test do
  desc "Run all specs & features"
  task :all => [ "spec", "features:all" ]
end

namespace :features do
  desc "Run all features"
  task :all => [ :webrat, :selenium ]
  
  desc "Run webrat features"
  task :webrat do
    sh "script/cucumber features --profile webrat"
  end
  
  desc "Run selenium features"
  task :selenium do
    sh "script/cucumber features --profile selenium"
  end
  
  desc "Run spanish features"
  task :selenium do
    sh "script/cucumber features --profile caracteristicas"
  end

end
