
  desc 'Continuous build tasks'
  task :cruise do
    CruiseControl::invoke_rake_task 'db:migrate'
    CruiseControl::invoke_rake_task 'cruise:test:all'
  end
  
  namespace :cruise do
    namespace :test do
      
      desc "Run all features with the required servers" 
      task :all do
        Rake::Task['spec'].invoke
        with_servers do
          Rake::Task['features:all'].invoke 
        end
      end
      
    end
  end
