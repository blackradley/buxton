#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
namespace :db do
  desc "Drop then recreate the dev database, migrate up, and load fixtures"
  task :remigrate => :environment do
    return unless %w[development test staging uat].include? Rails.env
    ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.drop_table t }
    Rake::Task["db:migrate"].invoke
    Rake::Task["spec:db:fixtures:load"].invoke
    Rake::Task["db:resync"].invoke
  end
end
