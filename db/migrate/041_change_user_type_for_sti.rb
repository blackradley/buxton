#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class ChangeUserTypeForSti < ActiveRecord::Migration
  def self.up
    change_column :users, :user_type, :string
    Rake::Task["db:convert_users_to_sti"].invoke    
    rename_column :users, :user_type, :type
  end

  def self.down
    rename_column :users, :type, :user_type
    change_column :users, :user_type, :integer
  end
end
