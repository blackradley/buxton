#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class FixAdditionalWorkQuestion4 < ActiveRecord::Migration
  def self.up
	change_column :functions, :additional_work_gender_8, :integer, :default => 0
	change_column :functions, :additional_work_race_8, :integer, :default => 0
	change_column :functions, :additional_work_disability_8, :integer, :default => 0
	change_column :functions, :additional_work_age_8, :integer, :default => 0
	change_column :functions, :additional_work_sexual_orientation_8, :integer, :default => 0
	change_column :functions, :additional_work_faith_8, :integer, :default => 0
  end

  def self.down
	change_column :functions, :additional_work_gender_8, :text
	change_column :functions, :additional_work_race_8, :integer, :text
	change_column :functions, :additional_work_disability_8, :text
	change_column :functions, :additional_work_age_8, :text
	change_column :functions, :additional_work_sexual_orientation_8, :text
	change_column :functions, :additional_work_faith_8, :text
  end
end
