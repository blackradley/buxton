#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class AddingExtraOrganisatonNeedsQuestions < ActiveRecord::Migration
  def self.up
    add_column :activities, :purpose_overall_10, :integer, :default => 0
    add_column :activities, :purpose_overall_11, :integer, :default => 0
    add_column :activities, :purpose_overall_12, :integer,  :default => 0
  end

  def self.down
    remove_column :activities, :purpose_overall_10
    remove_column :activities, :purpose_overall_11
    remove_column :activities, :purpose_overall_12
  end
end
