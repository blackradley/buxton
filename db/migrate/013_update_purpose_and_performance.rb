#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserve 
#
class UpdatePurposeAndPerformance < ActiveRecord::Migration
  def self.up
	rename_column :functions, :overall_performance,	:performance_overall_1
	rename_column :functions, :overall_validated,	:performance_overall_2
	rename_column :functions, :overall_validation_regime,	:performance_overall_3
	rename_column :functions, :overall_issues,	:performance_overall_4
	rename_column :functions, :overall_note_issues,	:performance_overall_5
	rename_column :functions, :gender_performance,	:performance_gender_1
	rename_column :functions, :gender_validated,	:performance_gender_2
	rename_column :functions, :gender_validation_regime,	:performance_gender_3
	rename_column :functions, :gender_issues,	:performance_gender_4
	rename_column :functions, :gender_note_issues,	:performance_gender_5
	rename_column :functions, :race_performance,	:performance_race_1
	rename_column :functions, :race_validated,	:performance_race_2
	rename_column :functions, :race_validation_regime,	:performance_race_3
	rename_column :functions, :race_issues,	:performance_race_4
	rename_column :functions, :race_note_issues,	:performance_race_5
	rename_column :functions, :disability_performance,	:performance_disability_1
	rename_column :functions, :disability_validated,	:performance_disability_2
	rename_column :functions, :disability_validation_regime,	:performance_disability_3
	rename_column :functions, :disability_issues,	:performance_disability_4
	rename_column :functions, :disability_note_issues,	:performance_disability_5
	rename_column :functions, :faith_performance,	:performance_faith_1
	rename_column :functions, :faith_validated,	:performance_faith_2
	rename_column :functions, :faith_validation_regime,	:performance_faith_3
	rename_column :functions, :faith_issues,	:performance_faith_4
	rename_column :functions, :faith_note_issues,	:performance_faith_5
	rename_column :functions, :sexual_orientation_performance,	:performance_sexual_orientation_1
	rename_column :functions, :sexual_orientation_validated,	:performance_sexual_orientation_2
	rename_column :functions, :sexual_orientation_validation_regime, :performance_sexual_orientation_3
	rename_column :functions, :sexual_orientation_issues,	:performance_sexual_orientation_4
	rename_column :functions, :sexual_orientation_note_issues,	:performance_sexual_orientation_5
	rename_column :functions, :age_performance,	:performance_age_1
	rename_column :functions, :age_validated,	:performance_age_2
	rename_column :functions, :age_validation_regime,	:performance_age_3
	rename_column :functions, :age_issues,	:performance_age_4
	rename_column :functions, :age_note_issues,	:performance_age_5
	
	rename_column :functions, :good_gender, :purpose_gender_4
	rename_column :functions, :good_race, :purpose_race_4
	rename_column :functions, :good_disability, :purpose_disability_4
	rename_column :functions, :good_faith, :purpose_faith_4
	rename_column :functions, :good_sexual_orientation, :purpose_sexual_orientation_4
	rename_column :functions, :good_age, :purpose_age_4
	rename_column :functions, :bad_gender, :purpose_gender_5
	rename_column :functions, :bad_race, :purpose_race_5
	rename_column :functions, :bad_disability, :purpose_disability_5
	rename_column :functions, :bad_faith, :purpose_faith_5
	rename_column :functions, :bad_sexual_orientation, :purpose_sexual_orientation_5
	rename_column :functions, :bad_age, :purpose_age_5
	
	add_column :functions, :purpose_gender_1, :integer, :default => 0
	add_column :functions, :purpose_gender_2, :text
	add_column :functions, :purpose_gender_3, :integer, :default => 0

	add_column :functions, :purpose_race_1, :integer, :default => 0
	add_column :functions, :purpose_race_2, :text
	add_column :functions, :purpose_race_3, :integer, :default => 0

	add_column :functions, :purpose_disability_1, :integer, :default => 0
	add_column :functions, :purpose_disability_2, :text
	add_column :functions, :purpose_disability_3, :integer, :default => 0

	add_column :functions, :purpose_sexual_orientation_1, :integer, :default => 0
	add_column :functions, :purpose_sexual_orientation_2, :text
	add_column :functions, :purpose_sexual_orientation_3, :integer, :default => 0

	add_column :functions, :purpose_age_1, :integer, :default => 0
	add_column :functions, :purpose_age_2, :text
	add_column :functions, :purpose_age_3, :integer, :default => 0
	
	add_column :functions, :purpose_overall_1, :integer, :default => 0
	add_column :functions, :purpose_overall_2, :text
	add_column :functions, :purpose_overall_3, :integer, :default => 0
	add_column :functions, :purpose_overall_4, :integer, :default => 0
	add_column :functions, :purpose_overall_5, :integer, :default => 0
  end

  def self.down
	rename_column :functions, 	:performance_overall_1,  :overall_performance
	rename_column :functions, 	:performance_overall_2,  :overall_validated
	rename_column :functions, 	:performance_overall_3,  :overall_validation_regime
	rename_column :functions, 	:performance_overall_4,  :overall_issues
	rename_column :functions, 	:performance_overall_5,  :overall_note_issues
	rename_column :functions, 	:performance_gender_1,  :gender_performance
	rename_column :functions, 	:performance_gender_2,  :gender_validated
	rename_column :functions, 	:performance_gender_3,  :gender_validation_regime
	rename_column :functions, 	:performance_gender_4,  :gender_issues
	rename_column :functions, 	:performance_gender_5,  :gender_note_issues
	rename_column :functions, 	:performance_race_1,  :race_performance
	rename_column :functions, 	:performance_race_2,  :race_validated
	rename_column :functions, 	:performance_race_3,  :race_validation_regime
	rename_column :functions, 	:performance_race_4,  :race_issues
	rename_column :functions, 	:performance_race_5,  :race_note_issues
	rename_column :functions, 	:performance_disability_1,  :disability_performance
	rename_column :functions, 	:performance_disability_2,  :disability_validated
	rename_column :functions, 	:performance_disability_3,  :disability_validation_regime
	rename_column :functions, 	:performance_disability_4,  :disability_issues
	rename_column :functions, 	:performance_disability_5,  :disability_note_issues
	rename_column :functions, 	:performance_faith_1,  :faith_performance
	rename_column :functions, 	:performance_faith_2,  :faith_validated
	rename_column :functions, 	:performance_faith_3,  :faith_validation_regime
	rename_column :functions, 	:performance_faith_4,  :faith_issues
	rename_column :functions, 	:performance_faith_5,  :faith_note_issues
	rename_column :functions, 	:performance_sexual_orientation_1,  :sexual_orientation_performance
	rename_column :functions, 	:performance_sexual_orientation_2,  :sexual_orientation_validated
	rename_column :functions, 	:performance_sexual_orientation_3,  :sexual_orientation_validation_regime
	rename_column :functions, 	:performance_sexual_orientation_4,  :sexual_orientation_issues
	rename_column :functions, 	:performance_sexual_orientation_5,  :sexual_orientation_note_issues
	rename_column :functions, 	:performance_age_1,  :age_performance
	rename_column :functions, 	:performance_age_2,  :age_validated
	rename_column :functions, 	:performance_age_3,  :age_validation_regime
	rename_column :functions, 	:performance_age_4,  :age_issues
	rename_column :functions, 	:performance_age_5,  :age_note_issues
	
	rename_column :functions,  :purpose_gender_4,  :good_gender
	rename_column :functions,  :purpose_race_4,  :good_race
	rename_column :functions,  :purpose_disability_4,  :good_disability
	rename_column :functions,  :purpose_faith_4,  :good_faith
	rename_column :functions,  :purpose_sexual_orientation_4,  :good_sexual_orientation
	rename_column :functions,  :purpose_age_4,  :good_age
	rename_column :functions,  :purpose_gender_5,  :bad_gender
	rename_column :functions,  :purpose_race_5,  :bad_race
	rename_column :functions,  :purpose_disability_5,  :bad_disability
	rename_column :functions,  :purpose_faith_5,  :bad_faith
	rename_column :functions,  :purpose_sexual_orientation_5,  :bad_sexual_orientation
	rename_column :functions,  :purpose_age_5,  :bad_age
	rename_column :functions,  :purpose_age_5,  :bad_age
	rename_column :functions,  :purpose_age_5,  :bad_age
	
	remove_column :functions, :purpose_gender_1, :integer, :default => 0
	remove_column :functions, :purpose_gender_2, :text
	remove_column :functions, :purpose_gender_3, :integer, :default => 0

	remove_column :functions, :purpose_race_1, :integer, :default => 0
	remove_column :functions, :purpose_race_2, :text
	remove_column :functions, :purpose_race_3, :integer, :default => 0

	remove_column :functions, :purpose_disability_1, :integer, :default => 0
	remove_column :functions, :purpose_disability_2, :text
	remove_column :functions, :purpose_disability_3, :integer, :default => 0

	remove_column :functions, :purpose_sexual_orientation_1, :integer, :default => 0
	remove_column :functions, :purpose_sexual_orientation_2, :text
	remove_column :functions, :purpose_sexual_orientation_3, :integer, :default => 0

	remove_column :functions, :purpose_race_1, :integer, :default => 0
	remove_column :functions, :purpose_race_2, :text
	remove_column :functions, :purpose_race_3, :integer, :default => 0
	
	remove_column :functions, :purpose_overall_1, :integer, :default => 0
	remove_column :functions, :purpose_overall_2, :text
	remove_column :functions, :purpose_overall_3, :integer, :default => 0
	remove_column :functions, :purpose_overall_4, :integer, :default => 0
	remove_column :functions, :purpose_overall_5, :integer, :default => 0
  end
end
