#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class AdditionalWorkQuestions < ActiveRecord::Migration
  def self.up
	add_column :functions, :additional_work_gender_1, :text
	add_column :functions, :additional_work_gender_2, :text
	add_column :functions, :additional_work_gender_3, :text
	add_column :functions, :additional_work_gender_4, :text
	add_column :functions, :additional_work_gender_5, :integer, :default => 0
	add_column :functions, :additional_work_gender_6, :text
	add_column :functions, :additional_work_gender_7, :integer, :default => 0
	add_column :functions, :additional_work_gender_8, :text
	add_column :functions, :additional_work_gender_9, :integer, :default => 0
	add_column :functions, :additional_work_gender_10, :integer, :default => 0
	add_column :functions, :additional_work_gender_11, :integer, :default => 0

	add_column :functions, :additional_work_race_1, :text
	add_column :functions, :additional_work_race_2, :text
	add_column :functions, :additional_work_race_3, :text
	add_column :functions, :additional_work_race_4, :text
	add_column :functions, :additional_work_race_5, :integer, :default => 0
	add_column :functions, :additional_work_race_6, :text
	add_column :functions, :additional_work_race_7, :integer, :default => 0
	add_column :functions, :additional_work_race_8, :text
	add_column :functions, :additional_work_race_9, :integer, :default => 0
	add_column :functions, :additional_work_race_10, :integer, :default => 0
	add_column :functions, :additional_work_race_11, :integer, :default => 0

	add_column :functions, :additional_work_disability_1, :text
	add_column :functions, :additional_work_disability_2, :text
	add_column :functions, :additional_work_disability_3, :text
	add_column :functions, :additional_work_disability_4, :text
	add_column :functions, :additional_work_disability_5, :integer, :default => 0
	add_column :functions, :additional_work_disability_6, :text
	add_column :functions, :additional_work_disability_7, :integer, :default => 0
	add_column :functions, :additional_work_disability_8, :text
	add_column :functions, :additional_work_disability_9, :integer, :default => 0
	add_column :functions, :additional_work_disability_10, :integer, :default => 0
	add_column :functions, :additional_work_disability_11, :integer, :default => 0
  add_column :functions, :additional_work_disability_12, :integer, :default => 0

	add_column :functions, :additional_work_sexual_orientation_1, :text
	add_column :functions, :additional_work_sexual_orientation_2, :text
	add_column :functions, :additional_work_sexual_orientation_3, :text
	add_column :functions, :additional_work_sexual_orientation_4, :text
	add_column :functions, :additional_work_sexual_orientation_5, :integer, :default => 0
	add_column :functions, :additional_work_sexual_orientation_6, :text
	add_column :functions, :additional_work_sexual_orientation_7, :integer, :default => 0
	add_column :functions, :additional_work_sexual_orientation_8, :text
	add_column :functions, :additional_work_sexual_orientation_9, :integer, :default => 0
	add_column :functions, :additional_work_sexual_orientation_10, :integer, :default => 0
	add_column :functions, :additional_work_sexual_orientation_11, :integer, :default => 0

	add_column :functions, :additional_work_age_1, :text
	add_column :functions, :additional_work_age_2, :text
	add_column :functions, :additional_work_age_3, :text
	add_column :functions, :additional_work_age_4, :text
	add_column :functions, :additional_work_age_5, :integer, :default => 0
	add_column :functions, :additional_work_age_6, :text
	add_column :functions, :additional_work_age_7, :integer, :default => 0
	add_column :functions, :additional_work_age_8, :text
	add_column :functions, :additional_work_age_9, :integer, :default => 0
	add_column :functions, :additional_work_age_10, :integer, :default => 0
	add_column :functions, :additional_work_age_11, :integer, :default => 0
  end

  def self.down
        remove_column :functions, :additional_work_gender_1, :text
	remove_column :functions, :additional_work_gender_2, :text
	remove_column :functions, :additional_work_gender_3, :text
	remove_column :functions, :additional_work_gender_4, :text
	remove_column :functions, :additional_work_gender_5, :integer, :default => 0
	remove_column :functions, :additional_work_gender_6, :text
	remove_column :functions, :additional_work_gender_7, :integer, :default => 0
	remove_column :functions, :additional_work_gender_8, :text
	remove_column :functions, :additional_work_gender_9, :integer, :default => 0
	remove_column :functions, :additional_work_gender_10, :integer, :default => 0
	remove_column :functions, :additional_work_gender_11, :integer, :default => 0

	remove_column :functions, :additional_work_race_1, :text
	remove_column :functions, :additional_work_race_2, :text
	remove_column :functions, :additional_work_race_3, :text
	remove_column :functions, :additional_work_race_4, :text
	remove_column :functions, :additional_work_race_5, :integer, :default => 0
	remove_column :functions, :additional_work_race_6, :text
	remove_column :functions, :additional_work_race_7, :integer, :default => 0
	remove_column :functions, :additional_work_race_8, :text
	remove_column :functions, :additional_work_race_9, :integer, :default => 0
	remove_column :functions, :additional_work_race_10, :integer, :default => 0
	remove_column :functions, :additional_work_race_11, :integer, :default => 0

	remove_column :functions, :additional_work_disability_1, :text
	remove_column :functions, :additional_work_disability_2, :text
	remove_column :functions, :additional_work_disability_3, :text
	remove_column :functions, :additional_work_disability_4, :text
	remove_column :functions, :additional_work_disability_5, :integer, :default => 0
	remove_column :functions, :additional_work_disability_6, :text
	remove_column :functions, :additional_work_disability_7, :integer, :default => 0
	remove_column :functions, :additional_work_disability_8, :text
	remove_column :functions, :additional_work_disability_9, :integer, :default => 0
	remove_column :functions, :additional_work_disability_10, :integer, :default => 0
	remove_column :functions, :additional_work_disability_11, :integer, :default => 0
  remove_column :functions, :additional_work_disability_12, :integer, :default => 0

	remove_column :functions, :additional_work_sexual_orientation_1, :text
	remove_column :functions, :additional_work_sexual_orientation_2, :text
	remove_column :functions, :additional_work_sexual_orientation_3, :text
	remove_column :functions, :additional_work_sexual_orientation_4, :text
	remove_column :functions, :additional_work_sexual_orientation_5, :integer, :default => 0
	remove_column :functions, :additional_work_sexual_orientation_6, :text
	remove_column :functions, :additional_work_sexual_orientation_7, :integer, :default => 0
	remove_column :functions, :additional_work_sexual_orientation_8, :text
	remove_column :functions, :additional_work_sexual_orientation_9, :integer, :default => 0
	remove_column :functions, :additional_work_sexual_orientation_10, :integer, :default => 0
	remove_column :functions, :additional_work_sexual_orientation_11, :integer, :default => 0

	remove_column :functions, :additional_work_age_1, :text
	remove_column :functions, :additional_work_age_2, :text
	remove_column :functions, :additional_work_age_3, :text
	remove_column :functions, :additional_work_age_4, :text
	remove_column :functions, :additional_work_age_5, :integer, :default => 0
	remove_column :functions, :additional_work_age_6, :text
	remove_column :functions, :additional_work_age_7, :integer, :default => 0
	remove_column :functions, :additional_work_age_8, :text
	remove_column :functions, :additional_work_age_9, :integer, :default => 0
	remove_column :functions, :additional_work_age_10, :integer, :default => 0
	remove_column :functions, :additional_work_age_11, :integer, :default => 0  
  end
end
