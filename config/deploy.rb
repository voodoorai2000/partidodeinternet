
  require File.expand_path(File.dirname(__FILE__) + '/environment')
  set :stages, %w(staging production)
  set :default_stage, 'staging'
  require 'capistrano/ext/multistage'
   
  default_run_options[:pty] = true 
  
  set :keep_releases, 10
  
  set :scm, :git
  set :repository,  "git@github.com:voodoorai2000/partidodeinternet.git"
  set :branch, "master"
  set :deploy_via, :checkout
  
  set :user, "deploy"
  set :port, "32200"  
  set :runner, "deploy"
  
  desc "create symbolic links for files outside of version control"
  task :create_symbolic_links, :roles => :app do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/db/schema.rb #{release_path}/db/schema.rb" 
  end
  
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
    
    
  namespace :deploy do
    %w(start restart).each { |name| task name, :roles => :app do mod_rails.restart end }
  
  end
  
  namespace :mod_rails do
    desc <<-DESC
    Restart the application altering tmp/restart.txt for mod_rails.
    DESC
    task :restart, :roles => :app do
      run "touch  #{release_path}/tmp/restart.txt"
    end
  end

  after "deploy:update_code", "create_symbolic_links"
  after "deploy:update", "deploy:cleanup" 
