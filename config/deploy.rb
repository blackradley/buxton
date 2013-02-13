require 'capistrano/ext/multistage'
# For RVM
# $:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, 'ree@brs'        # Or whatever env you want it to run in.
set :rvm_type, :user

# =============================================================================
# VARS
# =============================================================================
set :application, "buxton"
# set :repository,  "http://svn3.cvsdude.com/BlackRadley/buxton/trunk"

set :user, 'deploy'
set :runner, user
# set :scm_username, '27stars-karl'
# set :scm_password, 'dogstar'
# set :rake, '/opt/ruby-enterprise-1.8.6-20090201/bin/rake'

default_run_options[:pty] = true # We need to turn on the :pty option because it 
                                 # would seem we don’t get the passphrase prompt 
                                 # from git if we don’t.
set :scm_verbose, true
set :scm, "git"
set :repository, "git@github.com:blackradley/buxton.git"
set :repository_cache, "git_cache"
set :deploy_via, :remote_cache
set :database_yml_in_scm, false

set :keep_releases, 10
after 'deploy:update_code', 'deploy:cleanup'
# =============================================================================
# TASKS
# =============================================================================

ssh_options[:forward_agent] = true
# require 'bundler/capistrano'

namespace :bundler do
 task :create_symlink, :roles => :app do
   shared_dir = File.join(shared_path, 'bundle')
   release_dir = File.join(current_release, '.bundle')
   run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
 end

 task :bundle_new_release, :roles => :app do
   bundler.create_symlink
   run "cd #{release_path} && bundle install --without development test"
 end
end

task :shared_files, :roles => [:web] do
  # Make symlink for shared files
  SHARED_FILES = ['config/database.yml',
                  'public/images/organisations',
                  'doc/helptext.csv']
  SHARED_FILES.each do |file|
    run "ln -nfs #{shared_path}/#{file} #{release_path}/#{file}"
  end
  
  run "cd #{release_path} && bundle exec whenever --update-crontab #{application} --set environment=#{rails_env}"
end

desc "Update asset packager"
task :package_assets do
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

after 'deploy:update_code', 'bundler:bundle_new_release'
after 'deploy:update_code', 'shared_files'
after 'deploy:update_code', 'package_assets'


namespace :deploy do  
  task :start, :roles => :app do  
  end  

  task :stop, :roles => :app do  
  end  

  task :restart, :roles => :app do  
    run "touch #{release_path}/tmp/restart.txt"
  end  
end

# require './config/boot'
require 'airbrake/capistrano'
