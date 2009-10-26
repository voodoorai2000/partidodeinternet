
 set :rails_env, 'production'
 role :app, "#{PRODUCTION_SERVER_IP}"  
 role :web, "#{PRODUCTION_SERVER_IP}"  
 role :db,  "#{PRODUCTION_SERVER_IP}", :primary => true
 
 set :deploy_to, "/var/www/apps/#{PROJECT_NAME}"
 
 desc "create symbolic link to backup_fu.yml"
 task :create_symbolic_links_for_backups, :roles => :app do
   run "ln -nfs #{deploy_to}/#{shared_dir}/config/backup_fu.yml #{release_path}/config/backup_fu.yml" 
 end
 
 after "deploy:update_code", "create_symbolic_links_for_backups"
