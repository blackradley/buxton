#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
namespace :db do
  desc "Converts the users to use STI naming conventions."
  task :convert_users_to_sti => :environment do
    TYPE = {:administrative => '0',
      :organisational => '1',
      :functional => '2'}

    User.find(:all).each do |user|
      case user.user_type
      when TYPE[:administrative]
        user.user_type = 'Administrator'
      when TYPE[:organisational]
        user.user_type = 'OrganisationManager'
      when TYPE[:functional]
        user.user_type = 'FunctionManager'
      end
      user.save
    end    
  end
end