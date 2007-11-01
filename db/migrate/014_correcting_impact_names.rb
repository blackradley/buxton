#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class CorrectingImpactNames < ActiveRecord::Migration
  def self.up
	remove_column :functions, :purpose_gender_3
	remove_column :functions, :purpose_race_3
	remove_column :functions, :purpose_disability_3
	remove_column :functions, :purpose_sexual_orientation_3
	remove_column :functions, :purpose_age_3
	remove_column :functions, :purpose_overall_3 
	  
	rename_column :functions, :purpose_gender_4, :purpose_gender_3
	rename_column :functions, :purpose_race_4, :purpose_race_3
	rename_column :functions, :purpose_disability_4, :purpose_disability_3
	rename_column :functions, :purpose_faith_4, :purpose_faith_3
	rename_column :functions, :purpose_sexual_orientation_4, :purpose_sexual_orientation_3
	rename_column :functions, :purpose_age_4, :purpose_age_3
	rename_column :functions, :purpose_overall_4, :purpose_overall_3
	rename_column :functions, :purpose_gender_5, :purpose_gender_4
	rename_column :functions, :purpose_race_5, :purpose_race_4
	rename_column :functions, :purpose_disability_5, :purpose_disability_4
	rename_column :functions, :purpose_faith_5, :purpose_faith_4
	rename_column :functions, :purpose_sexual_orientation_5, :purpose_sexual_orientation_4
	rename_column :functions, :purpose_age_5, :purpose_age_4
	rename_column :functions, :purpose_overall_5, :purpose_overall_4
	
	rename_column :functions, :impact_service_users, :purpose_overall_5
	rename_column :functions, :impact_staff,  :purpose_overall_6
	rename_column :functions, :impact_supplier_staff,  :purpose_overall_7
	rename_column :functions, :impact_partner_staff,  :purpose_overall_8
	rename_column :functions, :impact_employees,  :purpose_overall_9	
	
	add_column :functions, :purpose_gender_5, :integer, :default => 0
	add_column :functions, :purpose_gender_6, :integer, :default => 0
	add_column :functions, :purpose_gender_7, :integer, :default => 0
	add_column :functions, :purpose_gender_8, :integer, :default => 0
	add_column :functions, :purpose_gender_9, :integer, :default => 0

	add_column :functions, :purpose_race_5, :integer, :default => 0
	add_column :functions, :purpose_race_6, :integer, :default => 0
	add_column :functions, :purpose_race_7, :integer, :default => 0
	add_column :functions, :purpose_race_8, :integer, :default => 0
	add_column :functions, :purpose_race_9, :integer, :default => 0

	add_column :functions, :purpose_disability_5, :integer, :default => 0
	add_column :functions, :purpose_disability_6, :integer, :default => 0
	add_column :functions, :purpose_disability_7, :integer, :default => 0
	add_column :functions, :purpose_disability_8, :integer, :default => 0
	add_column :functions, :purpose_disability_9, :integer, :default => 0

	add_column :functions, :purpose_faith_5, :integer, :default => 0
	add_column :functions, :purpose_faith_6, :integer, :default => 0
	add_column :functions, :purpose_faith_7, :integer, :default => 0
	add_column :functions, :purpose_faith_8, :integer, :default => 0
	add_column :functions, :purpose_faith_9, :integer, :default => 0

	add_column :functions, :purpose_sexual_orientation_5, :integer, :default => 0
	add_column :functions, :purpose_sexual_orientation_6, :integer, :default => 0
	add_column :functions, :purpose_sexual_orientation_7, :integer, :default => 0
	add_column :functions, :purpose_sexual_orientation_8, :integer, :default => 0
	add_column :functions, :purpose_sexual_orientation_9, :integer, :default => 0

	add_column :functions, :purpose_age_5, :integer, :default => 0
	add_column :functions, :purpose_age_6, :integer, :default => 0
	add_column :functions, :purpose_age_7, :integer, :default => 0
	add_column :functions, :purpose_age_8, :integer, :default => 0
	add_column :functions, :purpose_age_9, :integer, :default => 0
  end

  def self.down
	remove_column :functions, :purpose_gender_5, :integer, :default => 0
	remove_column :functions, :purpose_gender_6, :integer, :default => 0
	remove_column :functions, :purpose_gender_7, :integer, :default => 0
	remove_column :functions, :purpose_gender_8, :integer, :default => 0
	remove_column :functions, :purpose_gender_9, :integer, :default => 0

	remove_column :functions, :purpose_race_5, :integer, :default => 0
	remove_column :functions, :purpose_race_6, :integer, :default => 0
	remove_column :functions, :purpose_race_7, :integer, :default => 0
	remove_column :functions, :purpose_race_8, :integer, :default => 0
	remove_column :functions, :purpose_race_9, :integer, :default => 0

	remove_column :functions, :purpose_disability_5, :integer, :default => 0
	remove_column :functions, :purpose_disability_6, :integer, :default => 0
	remove_column :functions, :purpose_disability_7, :integer, :default => 0
	remove_column :functions, :purpose_disability_8, :integer, :default => 0
	remove_column :functions, :purpose_disability_9, :integer, :default => 0

	remove_column :functions, :purpose_faith_5, :integer, :default => 0
	remove_column :functions, :purpose_faith_6, :integer, :default => 0
	remove_column :functions, :purpose_faith_7, :integer, :default => 0
	remove_column :functions, :purpose_faith_8, :integer, :default => 0
	remove_column :functions, :purpose_faith_9, :integer, :default => 0

	remove_column :functions, :purpose_sexual_orientation_5, :integer, :default => 0
	remove_column :functions, :purpose_sexual_orientation_6, :integer, :default => 0
	remove_column :functions, :purpose_sexual_orientation_7, :integer, :default => 0
	remove_column :functions, :purpose_sexual_orientation_8, :integer, :default => 0
	remove_column :functions, :purpose_sexual_orientation_9, :integer, :default => 0

	remove_column :functions, :purpose_age_5, :integer, :default => 0
	remove_column :functions, :purpose_age_6, :integer, :default => 0
	remove_column :functions, :purpose_age_7, :integer, :default => 0
	remove_column :functions, :purpose_age_8, :integer, :default => 0
	remove_column :functions, :purpose_age_9, :integer, :default => 0
	
	rename_column :functions, :purpose_gender_3, :purpose_gender_4
	rename_column :functions, :purpose_race_3, :purpose_race_4
	rename_column :functions, :purpose_disability_3, :purpose_disability_4
	rename_column :functions, :purpose_faith_3, :purpose_faith_4
	rename_column :functions, :purpose_sexual_orientation_3, :purpose_sexual_orientation_4
	rename_column :functions, :purpose_age_3, :purpose_age_4
	rename_column :functions, :purpose_gender_4, :purpose_gender_5
	rename_column :functions, :purpose_race_4, :purpose_race_5
	rename_column :functions, :purpose_disability_4, :purpose_disability_5
	rename_column :functions, :purpose_faith_4, :purpose_faith_5
	rename_column :functions, :purpose_sexual_orientation_4, :purpose_sexual_orientation_5
	rename_column :functions, :purpose_age_4, :purpose_age_5
	rename_column :functions, :purpose_overall_5, :impact_service_users
	rename_column :functions, :purpose_overall_6, :impact_staff
	rename_column :functions, :purpose_overall_7, :impact_supplier_staff
	rename_column :functions, :purpose_overall_8, :impact_partner_staff
	rename_column :functions, :purpose_overall_9, :impact_employees
	
	add_column :functions, :purpose_gender_3
	add_column :functions, :purpose_race_3
	add_column :functions, :purpose_disability_3
	add_column :functions, :purpose_sexual_orientation_3
	add_column :functions, :purpose_age_3
	add_column :functions, :purpose_overall_3 
  end
end
