#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class AddApprovedToActivities < ActiveRecord::Migration
    def self.up
      remove_column :activities, :approver
      remove_column :activities, :approved
      add_column :activities, :approved, :string, :default => "not submitted"
    end

    def self.down
      remove_column :activities, :approved
      add_column :activities, :approver, :string
      add_column :activities, :approved, :boolean
    end
end
