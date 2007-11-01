#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class MoreFaithLessPurpose < ActiveRecord::Migration
  def self.up
	add_column :functions, :additional_work_faith_5, :integer, :default => 0
	add_column :functions, :additional_work_faith_6, :text
	add_column :functions, :additional_work_faith_7, :integer, :default => 0
	add_column :functions, :additional_work_faith_8, :text
	add_column :functions, :additional_work_faith_9, :integer, :default => 0
	add_column :functions, :additional_work_faith_10, :integer, :default => 0
	add_column :functions, :additional_work_faith_11, :integer, :default => 0
	
	remove_column :functions, :additional_work_disability_1
	remove_column :functions, :additional_work_disability_2
	remove_column :functions, :additional_work_disability_3
	remove_column :functions, :additional_work_disability_4
	
	remove_column :functions, :additional_work_race_1
	remove_column :functions, :additional_work_race_2
	remove_column :functions, :additional_work_race_3
	remove_column :functions, :additional_work_race_4
	
	remove_column :functions, :additional_work_gender_1
	remove_column :functions, :additional_work_gender_2
	remove_column :functions, :additional_work_gender_3
	remove_column :functions, :additional_work_gender_4
	
	remove_column :functions, :additional_work_sexual_orientation_1
	remove_column :functions, :additional_work_sexual_orientation_2
	remove_column :functions, :additional_work_sexual_orientation_3
	remove_column :functions, :additional_work_sexual_orientation_4
	
	remove_column :functions, :purpose_overall_1
	remove_column :functions, :purpose_gender_1
	remove_column :functions, :purpose_race_1
	remove_column :functions, :purpose_disability_1
	remove_column :functions, :purpose_faith_1
	remove_column :functions, :purpose_sexual_orientation_1
	remove_column :functions, :purpose_age_1
	
	remove_column :functions, :purpose_gender_2
	remove_column :functions, :purpose_race_2
	remove_column :functions, :purpose_disability_2
	remove_column :functions, :purpose_faith_2
	remove_column :functions, :purpose_sexual_orientation_2
	remove_column :functions, :purpose_age_2	
	
	remove_column :functions, :purpose_gender_5
	remove_column :functions, :purpose_race_5
	remove_column :functions, :purpose_disability_5
	remove_column :functions, :purpose_faith_5
	remove_column :functions, :purpose_sexual_orientation_5
	remove_column :functions, :purpose_age_5
	
	remove_column :functions, :purpose_gender_6
	remove_column :functions, :purpose_race_6
	remove_column :functions, :purpose_disability_6
	remove_column :functions, :purpose_faith_6
	remove_column :functions, :purpose_sexual_orientation_6
	remove_column :functions, :purpose_age_6
	
	remove_column :functions, :purpose_gender_7
	remove_column :functions, :purpose_race_7
	remove_column :functions, :purpose_disability_7
	remove_column :functions, :purpose_faith_7
	remove_column :functions, :purpose_sexual_orientation_7
	remove_column :functions, :purpose_age_7
	
	remove_column :functions, :purpose_gender_8
	remove_column :functions, :purpose_race_8
	remove_column :functions, :purpose_disability_8
	remove_column :functions, :purpose_faith_8
	remove_column :functions, :purpose_sexual_orientation_8
	remove_column :functions, :purpose_age_8
	
	remove_column :functions, :purpose_gender_9
	remove_column :functions, :purpose_race_9
	remove_column :functions, :purpose_disability_9
	remove_column :functions, :purpose_faith_9
	remove_column :functions, :purpose_sexual_orientation_9
	remove_column :functions, :purpose_age_9
	
	remove_column :functions, :purpose_overall_3
	remove_column :functions, :purpose_overall_4
  end

  def self.down
	remove_column :functions, :additional_work_faith_5
	remove_column :functions, :additional_work_faith_6
	remove_column :functions, :additional_work_faith_7
	remove_column :functions, :additional_work_faith_8
	remove_column :functions, :additional_work_faith_9
	remove_column :functions, :additional_work_faith_10
	remove_column :functions, :additional_work_faith_11
	
	add_column :functions, :additional_work_disability_1, :text
	add_column :functions, :additional_work_disability_2, :text
	add_column :functions, :additional_work_disability_3, :text
	add_column :functions, :additional_work_disability_4, :text
	
	add_column :functions, :additional_work_race_1, :text
	add_column :functions, :additional_work_race_2, :text
	add_column :functions, :additional_work_race_3, :text
	add_column :functions, :additional_work_race_4, :text
	
	add_column :functions, :additional_work_gender_1, :text
	add_column :functions, :additional_work_gender_2, :text
	add_column :functions, :additional_work_gender_3, :text
	add_column :functions, :additional_work_gender_4, :text
	
	add_column :functions, :additional_work_sexual_orientation_1, :text
	add_column :functions, :additional_work_sexual_orientation_2, :text
	add_column :functions, :additional_work_sexual_orientation_3, :text
	add_column :functions, :additional_work_sexual_orientation_4, :text
	
	add_column :functions, :purpose_overall_1, :integer, :default => 0
	add_column :functions, :purpose_gender_1, :integer, :default => 0
	add_column :functions, :purpose_race_1, :integer, :default => 0
	add_column :functions, :purpose_disability_1, :integer, :default => 0
	add_column :functions, :purpose_faith_1, :integer, :default => 0
	add_column :functions, :purpose_sexual_orientation_1, :integer, :default => 0
	add_column :functions, :purpose_age_1, :integer, :default => 0
	
	add_column :functions, :purpose_gender_2, :text
	add_column :functions, :purpose_race_2, :text
	add_column :functions, :purpose_disability_2, :text
	add_column :functions, :purpose_faith_2, :text
	add_column :functions, :purpose_sexual_orientation_2, :text
	add_column :functions, :purpose_age_2, :text	
	
	add_column :functions, :purpose_gender_5, :integer, :default => 0
	add_column :functions, :purpose_race_5, :integer, :default => 0
	add_column :functions, :purpose_disability_5, :integer, :default => 0
	add_column :functions, :purpose_faith_5, :integer, :default => 0
	add_column :functions, :purpose_sexual_orientation_5, :integer, :default => 0
	add_column :functions, :purpose_age_5, :integer, :default => 0
	
	add_column :functions, :purpose_gender_6, :integer, :default => 0
	add_column :functions, :purpose_race_6, :integer, :default => 0
	add_column :functions, :purpose_disability_6, :integer, :default => 0
	add_column :functions, :purpose_faith_6, :integer, :default => 0
	add_column :functions, :purpose_sexual_orientation_6, :integer, :default => 0
	add_column :functions, :purpose_age_6, :integer, :default => 0
	
	add_column :functions, :purpose_gender_7, :integer, :default => 0
	add_column :functions, :purpose_race_7, :integer, :default => 0
	add_column :functions, :purpose_disability_7, :integer, :default => 0
	add_column :functions, :purpose_faith_7, :integer, :default => 0
	add_column :functions, :purpose_sexual_orientation_7, :integer, :default => 0
	add_column :functions, :purpose_age_7, :integer, :default => 0
	
	add_column :functions, :purpose_gender_8, :integer, :default => 0
	add_column :functions, :purpose_race_8, :integer, :default => 0
	add_column :functions, :purpose_disability_8, :integer, :default => 0
	add_column :functions, :purpose_faith_8, :integer, :default => 0
	add_column :functions, :purpose_sexual_orientation_8, :integer, :default => 0
	add_column :functions, :purpose_age_8, :integer, :default => 0
	
	add_column :functions, :purpose_gender_9, :integer, :default => 0
	add_column :functions, :purpose_race_9, :integer, :default => 0
	add_column :functions, :purpose_disability_9, :integer, :default => 0
	add_column :functions, :purpose_faith_9, :integer, :default => 0
	add_column :functions, :purpose_sexual_orientation_9, :integer, :default => 0
	add_column :functions, :purpose_age_9, :integer, :default => 0
	
	add_column :functions, :purpose_overall_3, :integer, :default => 0
	add_column :functions, :purpose_overall_4, :integer, :default => 0	
  end
end
