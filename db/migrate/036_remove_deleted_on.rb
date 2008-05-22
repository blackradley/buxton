#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class RemoveDeletedOn < ActiveRecord::Migration
  def self.up
    remove_column :users, :deleted_on
    remove_column :functions, :deleted_on
    remove_column :organisations, :deleted_on
  end

  def self.down
    add_column :users, :deleted_on, :datetime
    add_column :functions, :deleted_on, :datetime
    add_column :organisations, :deleted_on, :datetime
  end
end
