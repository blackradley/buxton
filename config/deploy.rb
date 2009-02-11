require 'capistrano/ext/multistage'
require 'tinder'

# =============================================================================
# VARS
# =============================================================================
set :application, "buxton"
set :repository,  "http://svn3.cvsdude.com/BlackRadley/buxton/trunk"
set :port, 2020
set :user, 'deploy'
set :runner, user
set :scm_username, '27stars-karl'
set :scm_password, 'dogstar'
set :rake, '/opt/ruby-enterprise-1.8.6-20090201/bin/rake'
set :password, 'Buxton27'

# =============================================================================
# TASKS
# =============================================================================
task :after_update_code, :roles => [:web] do
  # Make symlink for shared files
  SHARED_FILES = ['config/database.yml',
                  'public/images/organisations']
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
      #{rake} RAILS_ENV=#{rails_env} #{task}
    EOF
  end
end

task :after_deploy, :roles => [:web] do
  campfire = Tinder::Campfire.new 'stars.campfirenow.com'
  campfire.login 'bot-deploy@27stars.co.uk', 'Bot27'
  exit unless room = campfire.find_room_by_name('All Talk')
  room.speak "Deployed #{application} to #{domain} in #{rails_env} mode."
  room.leave()
  campfire.logout()  
end

namespace :deploy do  
  task :start, :roles => :app do  
  end  

  task :stop, :roles => :app do  
  end  

  task :restart, :roles => :app do  
    run "touch #{release_path}/tmp/restart.txt"
  end  
end