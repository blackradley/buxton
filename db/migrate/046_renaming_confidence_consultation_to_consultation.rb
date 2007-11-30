class RenamingConfidenceConsultationToConsultation < ActiveRecord::Migration
  def self.up
    rename_column :functions, :confidence_consultation_age_1, :consultation_age_1
    rename_column :functions, :confidence_consultation_age_2, :consultation_age_2
    rename_column :functions, :confidence_consultation_age_3, :consultation_age_3
    rename_column :functions, :confidence_consultation_age_4, :consultation_age_4
    rename_column :functions, :confidence_consultation_age_5, :consultation_age_5
    rename_column :functions, :confidence_consultation_age_6, :consultation_age_6
    rename_column :functions, :confidence_consultation_age_7, :consultation_age_7
    
    rename_column :functions, :confidence_consultation_sexual_orientation_1, :consultation_sexual_orientation_1
    rename_column :functions, :confidence_consultation_sexual_orientation_2, :consultation_sexual_orientation_2
    rename_column :functions, :confidence_consultation_sexual_orientation_3, :consultation_sexual_orientation_3
    rename_column :functions, :confidence_consultation_sexual_orientation_4, :consultation_sexual_orientation_4
    rename_column :functions, :confidence_consultation_sexual_orientation_5, :consultation_sexual_orientation_5
    rename_column :functions, :confidence_consultation_sexual_orientation_6, :consultation_sexual_orientation_6
    rename_column :functions, :confidence_consultation_sexual_orientation_7, :consultation_sexual_orientation_7
    
    rename_column :functions, :confidence_consultation_disability_1, :consultation_disability_1
    rename_column :functions, :confidence_consultation_disability_2, :consultation_disability_2
    rename_column :functions, :confidence_consultation_disability_3, :consultation_disability_3
    rename_column :functions, :confidence_consultation_disability_4, :consultation_disability_4
    rename_column :functions, :confidence_consultation_disability_5, :consultation_disability_5
    rename_column :functions, :confidence_consultation_disability_6, :consultation_disability_6
    rename_column :functions, :confidence_consultation_disability_7, :consultation_disability_7
 
    rename_column :functions, :confidence_consultation_race_1, :consultation_race_1
    rename_column :functions, :confidence_consultation_race_2, :consultation_race_2
    rename_column :functions, :confidence_consultation_race_3, :consultation_race_3
    rename_column :functions, :confidence_consultation_race_4, :consultation_race_4
    rename_column :functions, :confidence_consultation_race_5, :consultation_race_5
    rename_column :functions, :confidence_consultation_race_6, :consultation_race_6
    rename_column :functions, :confidence_consultation_race_7, :consultation_race_7
    
    rename_column :functions, :confidence_consultation_faith_1, :consultation_faith_1
    rename_column :functions, :confidence_consultation_faith_2, :consultation_faith_2
    rename_column :functions, :confidence_consultation_faith_3, :consultation_faith_3
    rename_column :functions, :confidence_consultation_faith_4, :consultation_faith_4
    rename_column :functions, :confidence_consultation_faith_5, :consultation_faith_5
    rename_column :functions, :confidence_consultation_faith_6, :consultation_faith_6
    rename_column :functions, :confidence_consultation_faith_7, :consultation_faith_7
    
    rename_column :functions, :confidence_consultation_gender_1, :consultation_gender_1
    rename_column :functions, :confidence_consultation_gender_2, :consultation_gender_2
    rename_column :functions, :confidence_consultation_gender_3, :consultation_gender_3
    rename_column :functions, :confidence_consultation_gender_4, :consultation_gender_4
    rename_column :functions, :confidence_consultation_gender_5, :consultation_gender_5
    rename_column :functions, :confidence_consultation_gender_6, :consultation_gender_6
    rename_column :functions, :confidence_consultation_gender_7, :consultation_gender_7
  end

  def self.down
    rename_column :functions, :confidence_age_1, :confidence_consultation_age_1
    rename_column :functions, :confidence_age_2, :confidence_consultation_age_2
    rename_column :functions, :confidence_age_3, :confidence_consultation_age_3
    rename_column :functions, :confidence_age_4, :confidence_consultation_age_4
    rename_column :functions, :confidence_age_5, :confidence_consultation_age_5
    rename_column :functions, :confidence_age_6, :confidence_consultation_age_6
    rename_column :functions, :confidence_age_7, :confidence_consultation_age_7
    
    rename_column :functions, :confidence_sexual_orientation_1, :confidence_consultation_sexual_orientation_1
    rename_column :functions, :confidence_sexual_orientation_2, :confidence_consultation_sexual_orientation_2
    rename_column :functions, :confidence_sexual_orientation_3, :confidence_consultation_sexual_orientation_3
    rename_column :functions, :confidence_sexual_orientation_4, :confidence_consultation_sexual_orientation_4
    rename_column :functions, :confidence_sexual_orientation_5, :confidence_consultation_sexual_orientation_5
    rename_column :functions, :confidence_sexual_orientation_6, :confidence_consultation_sexual_orientation_6
    rename_column :functions, :confidence_sexual_orientation_7, :confidence_consultation_sexual_orientation_7
    
    rename_column :functions, :confidence_disability_1, :confidence_consultation_disability_1
    rename_column :functions, :confidence_disability_2, :confidence_consultation_disability_2
    rename_column :functions, :confidence_disability_3, :confidence_consultation_disability_3
    rename_column :functions, :confidence_disability_4, :confidence_consultation_disability_4
    rename_column :functions, :confidence_disability_5, :confidence_consultation_disability_5
    rename_column :functions, :confidence_disability_6, :confidence_consultation_disability_6
    rename_column :functions, :confidence_disability_7, :confidence_consultation_disability_7
 
    rename_column :functions, :confidence_race_1, :confidence_consultation_race_1
    rename_column :functions, :confidence_race_2, :confidence_consultation_race_2
    rename_column :functions, :confidence_race_3, :confidence_consultation_race_3
    rename_column :functions, :confidence_race_4, :confidence_consultation_race_4
    rename_column :functions, :confidence_race_5, :confidence_consultation_race_5
    rename_column :functions, :confidence_race_6, :confidence_consultation_race_6
    rename_column :functions, :confidence_race_7, :confidence_consultation_race_7
    
    rename_column :functions, :confidence_faith_1, :confidence_consultation_faith_1
    rename_column :functions, :confidence_faith_2, :confidence_consultation_faith_2
    rename_column :functions, :confidence_faith_3, :confidence_consultation_faith_3
    rename_column :functions, :confidence_faith_4, :confidence_consultation_faith_4
    rename_column :functions, :confidence_faith_5, :confidence_consultation_faith_5
    rename_column :functions, :confidence_faith_6, :confidence_consultation_faith_6
    rename_column :functions, :confidence_faith_7, :confidence_consultation_faith_7
    
    rename_column :functions, :confidence_gender_1, :confidence_consultation_gender_1
    rename_column :functions, :confidence_gender_2, :confidence_consultation_gender_2
    rename_column :functions, :confidence_gender_3, :confidence_consultation_gender_3
    rename_column :functions, :confidence_gender_4, :confidence_consultation_gender_4
    rename_column :functions, :confidence_gender_5, :confidence_consultation_gender_5
    rename_column :functions, :confidence_gender_6, :confidence_consultation_gender_6
    rename_column :functions, :confidence_gender_7, :confidence_consultation_gender_7
  end
end
