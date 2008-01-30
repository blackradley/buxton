# require 'mongrel_cluster/recipes'
require 'capistrano/ext/multistage'

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
after "deploy:update_code", "db:symlink" 

# database.yml task
namespace :db do
  desc "Make symlink for database and mongrel_cluster yaml files"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/mongrel_cluster.yml #{release_path}/config/mongrel_cluster.yml"
  end
end

# =============================================================================
# TASKS UNTIL CAPISTRANO 2 SUPPORTS MONGREL OUT-OF-THE-BOX
# =============================================================================
namespace :deploy do
  desc "Restart the mongrel cluster"
  task :restart, :roles => :app do
    invoke_command "/etc/init.d/mongrel_cluster restart"
  end
end