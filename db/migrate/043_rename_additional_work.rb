#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class RenameAdditionalWork < ActiveRecord::Migration
  def self.up
	rename_column :functions, :additional_work_race_5, :additional_work_race_1
	rename_column :functions, :additional_work_race_6, :additional_work_race_2
	rename_column :functions, :additional_work_race_7, :additional_work_race_3
	rename_column :functions, :additional_work_race_8, :additional_work_race_4
	rename_column :functions, :additional_work_race_9, :additional_work_race_5

	rename_column :functions, :additional_work_age_5, :additional_work_age_1
	rename_column :functions, :additional_work_age_6, :additional_work_age_2
	rename_column :functions, :additional_work_age_7, :additional_work_age_3
	rename_column :functions, :additional_work_age_8, :additional_work_age_4
	rename_column :functions, :additional_work_age_9, :additional_work_age_5

	rename_column :functions, :additional_work_sexual_orientation_5, :additional_work_sexual_orientation_1
	rename_column :functions, :additional_work_sexual_orientation_6, :additional_work_sexual_orientation_2
	rename_column :functions, :additional_work_sexual_orientation_7, :additional_work_sexual_orientation_3
	rename_column :functions, :additional_work_sexual_orientation_8, :additional_work_sexual_orientation_4
	rename_column :functions, :additional_work_sexual_orientation_9, :additional_work_sexual_orientation_5

	rename_column :functions, :additional_work_faith_5, :additional_work_faith_1
	rename_column :functions, :additional_work_faith_6, :additional_work_faith_2
	rename_column :functions, :additional_work_faith_7, :additional_work_faith_3
	rename_column :functions, :additional_work_faith_8, :additional_work_faith_4
	rename_column :functions, :additional_work_faith_9, :additional_work_faith_5

	rename_column :functions, :additional_work_gender_5, :additional_work_gender_1
	rename_column :functions, :additional_work_gender_6, :additional_work_gender_2
	rename_column :functions, :additional_work_gender_7, :additional_work_gender_3
	rename_column :functions, :additional_work_gender_8, :additional_work_gender_4
	rename_column :functions, :additional_work_gender_9, :additional_work_gender_5


	rename_column :functions, :additional_work_disability_5, :additional_work_disability_1
	rename_column :functions, :additional_work_disability_6, :additional_work_disability_2
	rename_column :functions, :additional_work_disability_7, :additional_work_disability_3
	rename_column :functions, :additional_work_disability_8, :additional_work_disability_4
	rename_column :functions, :additional_work_disability_9, :additional_work_disability_5
	rename_column :functions, :additional_work_disability_10, :additional_work_disability_6
	rename_column :functions, :additional_work_disability_11, :additional_work_disability_7
	rename_column :functions, :additional_work_disability_12, :additional_work_disability_8
	rename_column :functions, :additional_work_disability_13, :additional_work_disability_9
	rename_column :functions, :additional_work_disability_14, :additional_work_disability_10
  end

  def self.down
	rename_column :functions, :additional_work_race_1, :additional_work_race_5
	rename_column :functions, :additional_work_race_2, :additional_work_race_6 
	rename_column :functions, :additional_work_race_3, :additional_work_race_7 
	rename_column :functions, :additional_work_race_4, :additional_work_race_8 
	rename_column :functions, :additional_work_race_5, :additional_work_race_9 

	rename_column :functions, :additional_work_age_1, :additional_work_age_5
	rename_column :functions, :additional_work_age_2, :additional_work_age_6
	rename_column :functions, :additional_work_age_3, :additional_work_age_7 
	rename_column :functions, :additional_work_age_4, :additional_work_age_8 
	rename_column :functions, :additional_work_age_5, :additional_work_age_9 

	rename_column :functions, :additional_work_sexual_orientation_1, :additional_work_sexual_orientation_5 
	rename_column :functions, :additional_work_sexual_orientation_2, :additional_work_sexual_orientation_6 
	rename_column :functions, :additional_work_sexual_orientation_3, :additional_work_sexual_orientation_7 
	rename_column :functions, :additional_work_sexual_orientation_4, :additional_work_sexual_orientation_8 
	rename_column :functions, :additional_work_sexual_orientation_5, :additional_work_sexual_orientation_9 

	rename_column :functions, :additional_work_faith_1, :additional_work_faith_5
	rename_column :functions, :additional_work_faith_2, :additional_work_faith_6
	rename_column :functions, :additional_work_faith_3, :additional_work_faith_7
	rename_column :functions, :additional_work_faith_4, :additional_work_faith_8
	rename_column :functions, :additional_work_faith_5, :additional_work_faith_9

	rename_column :functions, :additional_work_gender_1, :additional_work_gender_5
	rename_column :functions, :additional_work_gender_2, :additional_work_gender_6
	rename_column :functions, :additional_work_gender_3, :additional_work_gender_7
	rename_column :functions, :additional_work_gender_4, :additional_work_gender_8
	rename_column :functions, :additional_work_gender_5, :additional_work_gender_9


	rename_column :functions, :additional_work_disability_1, :additional_work_disability_5
	rename_column :functions, :additional_work_disability_2, :additional_work_disability_6
	rename_column :functions, :additional_work_disability_3, :additional_work_disability_7
	rename_column :functions, :additional_work_disability_4, :additional_work_disability_8
	rename_column :functions, :additional_work_disability_5, :additional_work_disability_9
	rename_column :functions, :additional_work_disability_6, :additional_work_disability_10
	rename_column :functions, :additional_work_disability_7, :additional_work_disability_11
	rename_column :functions, :additional_work_disability_8, :additional_work_disability_12
	rename_column :functions, :additional_work_disability_9, :additional_work_disability_13
	rename_column :functions, :additional_work_disability_10, :additional_work_disability_14

  end
end
