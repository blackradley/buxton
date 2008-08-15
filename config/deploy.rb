# require 'mongrel_cluster/recipes'
require 'capistrano/ext/multistage'

require 'rubygems'
require 'tinder'

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
set :application, "buxton"
set :repository,  "http://svn3.cvsdude.com/BlackRadley/buxton/trunk"
set :port, 1417

# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
set :user, 'buxton'
set :scm_username, '27stars-karl'
set :scm_password, 'dogstar'
set :rake, "/usr/local/rubygems/gems/bin/rake"

# =============================================================================
# TASKS
# =============================================================================
task :after_update_code, :roles => [:web] do
  # Make symlink for shared files
  SHARED_FILES = ['/config/database.yml',
                  '/config/mongrel_cluster.yml',
                  '/public/images/organisations']
  SHARED_FILES.each do |file|
    run "ln -nfs #{shared_path}/#{file} #{release_path}/#{file}"
  end
  
  # Produce CSS files ready for asset_packager, then build assets
  # (General SASS files first, then template colour schemes, then asset_packager)
  TASKS = ['asset:packager:delete_all',
           'asset:packager:build_all']
  TASKS.each do |task|
    run <<-EOF
      cd #{release_path} &&
      rake RAILS_ENV=#{rails_env} #{task}
    EOF
  end
end

task :after_update_code, :roles => [:web] do
  # Make symlink for database and mongrel_cluster yaml files
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{shared_path}/config/mongrel_cluster.yml #{release_path}/config/mongrel_cluster.yml"  
end

task :after_deploy, :roles => [:web] do
  campfire = Tinder::Campfire.new 'stars.campfirenow.com'
  campfire.login 'bot-deploy@27stars.co.uk', 'Bot27'
  exit unless room = campfire.find_room_by_name('All Talk')
  room.speak "Deployed #{application} to #{domain} in #{rails_env} mode."
  room.leave()
  campfire.logout()  
end

# =============================================================================
# TASKS FOR MONGREL UNTIL CAP 2 SUPPORTS IT NATIVELY
# =============================================================================
namespace :deploy do
  namespace :mongrel do
    [ :stop, :start, :restart ].each do |t|
      desc "#{t.to_s.capitalize} the mongrel appserver"
      task t, :roles => :app do
        #invoke_command checks the use_sudo variable to determine how to run the mongrel_rails command
        invoke_command "mongrel_rails cluster::#{t.to_s} -C #{mongrel_conf}", :via => run_method
      end
    end
  end

  desc "Custom restart task for mongrel cluster"
  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.mongrel.restart
  end

  desc "Custom start task for mongrel cluster"
  task :start, :roles => :app do
    deploy.mongrel.start
  end

  desc "Custom stop task for mongrel cluster"
  task :stop, :roles => :app do
    deploy.mongrel.stop
  end

end

# =============================================================================
# ENVIRONMENT DEBUGGING
# =============================================================================
desc "Echo environment vars" 
namespace :env do
  task :echo do
    run "echo printing out cap info on remote server"
    run "echo $PATH"
    run "printenv"
  end
end