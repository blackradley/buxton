#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class OrganisationThroughDirectorate < ActiveRecord::Migration
  def self.up
    remove_column :activities, :organisation_id    
  end

  def self.down
    add_column :activities, :organisation_id, :integer
  end
end