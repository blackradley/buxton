# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
set :application, "webwelcome.net"
set :repository,  "http://svn3.cvsdude.com/BlackRadley/buxton/trunk"
set :domain, application

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