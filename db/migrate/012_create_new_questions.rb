class CreateNewQuestions < ActiveRecord::Migration
  def self.up	  
	add_column :functions, :confidence_information_overall_1, :integer, :default => 0
	add_column :functions, :confidence_information_overall_2, :integer, :default => 0
	add_column :functions, :confidence_information_overall_3, :integer, :default => 0
	add_column :functions, :confidence_information_overall_4, :integer, :default => 0
	add_column :functions, :confidence_information_overall_5,  :text

	add_column :functions, :confidence_information_gender_1, :integer, :default => 0
	add_column :functions, :confidence_information_gender_2, :integer, :default => 0
	add_column :functions, :confidence_information_gender_3, :integer, :default => 0
	add_column :functions, :confidence_information_gender_4, :integer, :default => 0
	add_column :functions, :confidence_information_gender_5,  :text

	add_column :functions, :confidence_information_race_1, :integer, :default => 0
	add_column :functions, :confidence_information_race_2, :integer, :default => 0
	add_column :functions, :confidence_information_race_3, :integer, :default => 0
	add_column :functions, :confidence_information_race_4, :integer, :default => 0
	add_column :functions, :confidence_information_race_5,  :text

	add_column :functions, :confidence_information_disability_1, :integer, :default => 0
	add_column :functions, :confidence_information_disability_2, :integer, :default => 0
	add_column :functions, :confidence_information_disability_3, :integer, :default => 0
	add_column :functions, :confidence_information_disability_4, :integer, :default => 0
	add_column :functions, :confidence_information_disability_5,  :text

	add_column :functions, :confidence_information_faith_1, :integer, :default => 0
	add_column :functions, :confidence_information_faith_2, :integer, :default => 0
	add_column :functions, :confidence_information_faith_3, :integer, :default => 0
	add_column :functions, :confidence_information_faith_4, :integer, :default => 0
	add_column :functions, :confidence_information_faith_5,  :text

	add_column :functions, :confidence_information_sexual_orientation_1, :integer, :default => 0
	add_column :functions, :confidence_information_sexual_orientation_2, :integer, :default => 0
	add_column :functions, :confidence_information_sexual_orientation_3, :integer, :default => 0
	add_column :functions, :confidence_information_sexual_orientation_4, :integer, :default => 0
	add_column :functions, :confidence_information_sexual_orientation_5,  :text

	add_column :functions, :confidence_information_age_1, :integer, :default => 0
	add_column :functions, :confidence_information_age_2, :integer, :default => 0
	add_column :functions, :confidence_information_age_3, :integer, :default => 0
	add_column :functions, :confidence_information_age_4, :integer, :default => 0
	add_column :functions, :confidence_information_age_5,  :text
	
	
	add_column :functions, :confidence_consultation_gender_2, :integer, :default => 0
	add_column :functions, :confidence_consultation_gender_3, :text
	add_column :functions, :confidence_consultation_gender_4, :integer, :default => 0
	add_column :functions, :confidence_consultation_gender_5, :integer, :default => 0
	add_column :functions, :confidence_consultation_gender_6, :text
	add_column :functions, :confidence_consultation_gender_7, :integer, :default => 0
	add_column :functions, :confidence_consultation_gender_8, :text

	add_column :functions, :confidence_consultation_race_1, :integer, :default => 0
	add_column :functions, :confidence_consultation_race_2, :integer, :default => 0
	add_column :functions, :confidence_consultation_race_3, :text
	add_column :functions, :confidence_consultation_race_4, :integer, :default => 0
	add_column :functions, :confidence_consultation_race_5, :integer, :default => 0
	add_column :functions, :confidence_consultation_race_6, :text
	add_column :functions, :confidence_consultation_race_7, :integer, :default => 0
	add_column :functions, :confidence_consultation_race_8, :text

	add_column :functions, :confidence_consultation_disability_1, :integer, :default => 0
	add_column :functions, :confidence_consultation_disability_2, :integer, :default => 0
	add_column :functions, :confidence_consultation_disability_3, :text
	add_column :functions, :confidence_consultation_disability_4, :integer, :default => 0
	add_column :functions, :confidence_consultation_disability_5, :integer, :default => 0
	add_column :functions, :confidence_consultation_disability_6, :text
	add_column :functions, :confidence_consultation_disability_7, :integer, :default => 0
	add_column :functions, :confidence_consultation_disability_8, :text

	add_column :functions, :confidence_consultation_faith_1, :integer, :default => 0
	add_column :functions, :confidence_consultation_faith_2, :integer, :default => 0
	add_column :functions, :confidence_consultation_faith_3, :text
	add_column :functions, :confidence_consultation_faith_4, :integer, :default => 0
	add_column :functions, :confidence_consultation_faith_5, :integer, :default => 0
	add_column :functions, :confidence_consultation_faith_6, :text
	add_column :functions, :confidence_consultation_faith_7, :integer, :default => 0
	add_column :functions, :confidence_consultation_faith_8, :text

	add_column :functions, :confidence_consultation_sexual_orientation_1, :integer, :default => 0
	add_column :functions, :confidence_consultation_sexual_orientation_2, :integer, :default => 0
	add_column :functions, :confidence_consultation_sexual_orientation_3, :text
	add_column :functions, :confidence_consultation_sexual_orientation_4, :integer, :default => 0
	add_column :functions, :confidence_consultation_sexual_orientation_5, :integer, :default => 0
	add_column :functions, :confidence_consultation_sexual_orientation_6, :text
	add_column :functions, :confidence_consultation_sexual_orientation_7, :integer, :default => 0
	add_column :functions, :confidence_consultation_sexual_orientation_8, :text

	add_column :functions, :confidence_consultation_age_1, :integer, :default => 0
	add_column :functions, :confidence_consultation_age_2, :integer, :default => 0
	add_column :functions, :confidence_consultation_age_3, :text
	add_column :functions, :confidence_consultation_age_4, :integer, :default => 0
	add_column :functions, :confidence_consultation_age_5, :integer, :default => 0
	add_column :functions, :confidence_consultation_age_6, :text
	add_column :functions, :confidence_consultation_age_7, :integer, :default => 0
	add_column :functions, :confidence_consultation_age_8, :text
	
	
  end

  def self.down
	remove_column :functions, :confidence_information_overall_1
	remove_column :functions, :confidence_information_overall_2
	remove_column :functions, :confidence_information_overall_3
	remove_column :functions, :confidence_information_overall_4
	remove_column :functions, :confidence_information_overall_5

	remove_column :functions, :confidence_information_gender_1
	remove_column :functions, :confidence_information_gender_2
	remove_column :functions, :confidence_information_gender_3
	remove_column :functions, :confidence_information_gender_4
	remove_column :functions, :confidence_information_gender_5

	remove_column :functions, :confidence_information_race_1
	remove_column :functions, :confidence_information_race_2
	remove_column :functions, :confidence_information_race_3
	remove_column :functions, :confidence_information_race_4
	remove_column :functions, :confidence_information_race_5

	remove_column :functions, :confidence_information_disability_1
	remove_column :functions, :confidence_information_disability_2
	remove_column :functions, :confidence_information_disability_3
	remove_column :functions, :confidence_information_disability_4
	remove_column :functions, :confidence_information_disability_5

	remove_column :functions, :confidence_information_faith_1
	remove_column :functions, :confidence_information_faith_2
	remove_column :functions, :confidence_information_faith_3
	remove_column :functions, :confidence_information_faith_4
	remove_column :functions, :confidence_information_faith_5

	remove_column :functions, :confidence_information_sexual_orientation_1
	remove_column :functions, :confidence_information_sexual_orientation_2
	remove_column :functions, :confidence_information_sexual_orientation_3
	remove_column :functions, :confidence_information_sexual_orientation_4
	remove_column :functions, :confidence_information_sexual_orientation_5

	remove_column :functions, :confidence_information_age_1
	remove_column :functions, :confidence_information_age_2
	remove_column :functions, :confidence_information_age_3
	remove_column :functions, :confidence_information_age_4
	remove_column :functions, :confidence_information_age_5
	
	
	remove_column :functions, :confidence_consultation_gender_2
	remove_column :functions, :confidence_consultation_gender_3
	remove_column :functions, :confidence_consultation_gender_4
	remove_column :functions, :confidence_consultation_gender_5
	remove_column :functions, :confidence_consultation_gender_6
	remove_column :functions, :confidence_consultation_gender_7
	remove_column :functions, :confidence_consultation_gender_8

	remove_column :functions, :confidence_consultation_race_1
	remove_column :functions, :confidence_consultation_race_2
	remove_column :functions, :confidence_consultation_race_3
	remove_column :functions, :confidence_consultation_race_4
	remove_column :functions, :confidence_consultation_race_5
	remove_column :functions, :confidence_consultation_race_6
	remove_column :functions, :confidence_consultation_race_7
	remove_column :functions, :confidence_consultation_race_8

	remove_column :functions, :confidence_consultation_disability_1
	remove_column :functions, :confidence_consultation_disability_2
	remove_column :functions, :confidence_consultation_disability_3
	remove_column :functions, :confidence_consultation_disability_4
	remove_column :functions, :confidence_consultation_disability_5
	remove_column :functions, :confidence_consultation_disability_6
	remove_column :functions, :confidence_consultation_disability_7
	remove_column :functions, :confidence_consultation_disability_8

	remove_column :functions, :confidence_consultation_faith_1
	remove_column :functions, :confidence_consultation_faith_2
	remove_column :functions, :confidence_consultation_faith_3
	remove_column :functions, :confidence_consultation_faith_4
	remove_column :functions, :confidence_consultation_faith_5
	remove_column :functions, :confidence_consultation_faith_6
	remove_column :functions, :confidence_consultation_faith_7
	remove_column :functions, :confidence_consultation_faith_8

	remove_column :functions, :confidence_consultation_sexual_orientation_1
	remove_column :functions, :confidence_consultation_sexual_orientation_2
	remove_column :functions, :confidence_consultation_sexual_orientation_3
	remove_column :functions, :confidence_consultation_sexual_orientation_4
	remove_column :functions, :confidence_consultation_sexual_orientation_5
	remove_column :functions, :confidence_consultation_sexual_orientation_6
	remove_column :functions, :confidence_consultation_sexual_orientation_7
	remove_column :functions, :confidence_consultation_sexual_orientation_8

	remove_column :functions, :confidence_consultation_age_1
	remove_column :functions, :confidence_consultation_age_2
	remove_column :functions, :confidence_consultation_age_3
	remove_column :functions, :confidence_consultation_age_4
	remove_column :functions, :confidence_consultation_age_5
	remove_column :functions, :confidence_consultation_age_6
	remove_column :functions, :confidence_consultation_age_7
	remove_column :functions, :confidence_consultation_age_8
  end
end
