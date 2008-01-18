# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
set :application, "Buxton"
set :repository,  "http://svn3.cvsdude.com/BlackRadley/buxton/trunk"
set :domain, "72.47.213.74"

# =============================================================================
# ROLES
# =============================================================================
role :app, domain
role :web, domain
role :db,  domain, :primary => true

# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
set :deploy_to, "/var/www/vhosts/webwelcome.net/rails/testapp"
set :user, 'buxton'
set :scm_username, '27stars-karl'
set :scm_password, 'dogstar'
set :rake, "/usr/local/rubygems/gems/bin/rake"
# set :use_sudo, false

# =============================================================================
# TASKS
# =============================================================================
after "deploy:update_code", "db:symlink" 

# database.yml task
namespace :db do
  desc "Make symlink for database yaml" 
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
end

# =============================================================================
# TASKS UNTIL CAPISTRANO 2 SUPPORTS MONGREL OUT-OF-THE-BOX
# =============================================================================
namespace :deploy do
  namespace :mongrel do
    [ :stop, :start, :restart ].each do |t|
      desc "#{t.to_s.capitalize} the mongrel appserver"
      task t, :roles => :app do
        #invoke_command checks the use_sudo variable to determine how to run the mongrel_rails command
        invoke_command "/etc/init.d/mongrel_cluster #{t.to_s}", :via => run_method
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