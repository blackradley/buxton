#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class CreatingImpact < ActiveRecord::Migration
  def self.up
    rename_column :functions, :performance_age_1, :impact_age_1
    rename_column :functions, :performance_age_2, :impact_age_2
    rename_column :functions, :performance_age_3, :impact_age_3
    rename_column :functions, :performance_age_4, :impact_age_4
    rename_column :functions, :performance_age_5, :impact_age_5
    rename_column :functions, :confidence_information_age_1, :impact_age_6
    rename_column :functions, :confidence_information_age_2, :impact_age_7
    rename_column :functions, :confidence_information_age_3, :impact_age_8
    rename_column :functions, :confidence_information_age_4, :impact_age_9
    rename_column :functions, :confidence_information_age_5, :impact_age_10
    
    rename_column :functions, :performance_disability_1, :impact_disability_1
    rename_column :functions, :performance_disability_2, :impact_disability_2
    rename_column :functions, :performance_disability_3, :impact_disability_3
    rename_column :functions, :performance_disability_4, :impact_disability_4
    rename_column :functions, :performance_disability_5, :impact_disability_5
    rename_column :functions, :confidence_information_disability_1, :impact_disability_6
    rename_column :functions, :confidence_information_disability_2, :impact_disability_7
    rename_column :functions, :confidence_information_disability_3, :impact_disability_8
    rename_column :functions, :confidence_information_disability_4, :impact_disability_9
    rename_column :functions, :confidence_information_disability_5, :impact_disability_10
    
    rename_column :functions, :performance_sexual_orientation_1, :impact_sexual_orientation_1
    rename_column :functions, :performance_sexual_orientation_2, :impact_sexual_orientation_2
    rename_column :functions, :performance_sexual_orientation_3, :impact_sexual_orientation_3
    rename_column :functions, :performance_sexual_orientation_4, :impact_sexual_orientation_4
    rename_column :functions, :performance_sexual_orientation_5, :impact_sexual_orientation_5
    rename_column :functions, :confidence_information_sexual_orientation_1, :impact_sexual_orientation_6
    rename_column :functions, :confidence_information_sexual_orientation_2, :impact_sexual_orientation_7
    rename_column :functions, :confidence_information_sexual_orientation_3, :impact_sexual_orientation_8
    rename_column :functions, :confidence_information_sexual_orientation_4, :impact_sexual_orientation_9
    rename_column :functions, :confidence_information_sexual_orientation_5, :impact_sexual_orientation_10
    
    rename_column :functions, :performance_faith_1, :impact_faith_1
    rename_column :functions, :performance_faith_2, :impact_faith_2
    rename_column :functions, :performance_faith_3, :impact_faith_3
    rename_column :functions, :performance_faith_4, :impact_faith_4
    rename_column :functions, :performance_faith_5, :impact_faith_5
    rename_column :functions, :confidence_information_faith_1, :impact_faith_6
    rename_column :functions, :confidence_information_faith_2, :impact_faith_7
    rename_column :functions, :confidence_information_faith_3, :impact_faith_8
    rename_column :functions, :confidence_information_faith_4, :impact_faith_9
    rename_column :functions, :confidence_information_faith_5, :impact_faith_10
    
    rename_column :functions, :performance_race_1, :impact_race_1
    rename_column :functions, :performance_race_2, :impact_race_2
    rename_column :functions, :performance_race_3, :impact_race_3
    rename_column :functions, :performance_race_4, :impact_race_4
    rename_column :functions, :performance_race_5, :impact_race_5
    rename_column :functions, :confidence_information_race_1, :impact_race_6
    rename_column :functions, :confidence_information_race_2, :impact_race_7
    rename_column :functions, :confidence_information_race_3, :impact_race_8
    rename_column :functions, :confidence_information_race_4, :impact_race_9
    rename_column :functions, :confidence_information_race_5, :impact_race_10
    
    rename_column :functions, :performance_gender_1, :impact_gender_1
    rename_column :functions, :performance_gender_2, :impact_gender_2
    rename_column :functions, :performance_gender_3, :impact_gender_3
    rename_column :functions, :performance_gender_4, :impact_gender_4
    rename_column :functions, :performance_gender_5, :impact_gender_5
    rename_column :functions, :confidence_information_gender_1, :impact_gender_6
    rename_column :functions, :confidence_information_gender_2, :impact_gender_7
    rename_column :functions, :confidence_information_gender_3, :impact_gender_8
    rename_column :functions, :confidence_information_gender_4, :impact_gender_9
    rename_column :functions, :confidence_information_gender_5, :impact_gender_10
  end

  def self.down
  
    rename_column :functions, :impact_age_1, :performance_age_1
    rename_column :functions, :impact_age_2, :performance_age_2
    rename_column :functions, :impact_age_3, :performance_age_3
    rename_column :functions, :impact_age_4, :performance_age_4
    rename_column :functions, :impact_age_5, :performance_age_5
    rename_column :functions, :impact_age_1, :confidence_information_age_6
    rename_column :functions, :impact_age_2, :confidence_information_age_7
    rename_column :functions, :impact_age_3, :confidence_information_age_8
    rename_column :functions, :impact_age_4, :confidence_information_age_9
    rename_column :functions, :impact_age_5, :confidence_information_age_10
    
    rename_column :functions, :impact_disability_1, :performance_disability_1
    rename_column :functions, :impact_disability_2, :performance_disability_2
    rename_column :functions, :impact_disability_3, :performance_disability_3
    rename_column :functions, :impact_disability_4, :performance_disability_4
    rename_column :functions, :impact_disability_5, :performance_disability_5
    rename_column :functions, :impact_disability_1, :confidence_information_disability_6
    rename_column :functions, :impact_disability_2, :confidence_information_disability_7
    rename_column :functions, :impact_disability_3, :confidence_information_disability_8
    rename_column :functions, :impact_disability_4, :confidence_information_disability_9
    rename_column :functions, :impact_disability_5, :confidence_information_disability_10
    
    rename_column :functions, :impact_sexual_orientation_1, :performance_sexual_orientation_1
    rename_column :functions, :impact_sexual_orientation_2, :performance_sexual_orientation_2
    rename_column :functions, :impact_sexual_orientation_3, :performance_sexual_orientation_3
    rename_column :functions, :impact_sexual_orientation_4, :performance_sexual_orientation_4
    rename_column :functions, :impact_sexual_orientation_5, :performance_sexual_orientation_5
    rename_column :functions, :impact_sexual_orientation_1, :confidence_information_sexual_orientation_6
    rename_column :functions, :impact_sexual_orientation_2, :confidence_information_sexual_orientation_7
    rename_column :functions, :impact_sexual_orientation_3, :confidence_information_sexual_orientation_8
    rename_column :functions, :impact_sexual_orientation_4, :confidence_information_sexual_orientation_9
    rename_column :functions, :impact_sexual_orientation_5, :confidence_information_sexual_orientation_10
    
    rename_column :functions, :impact_faith_1, :performance_faith_1
    rename_column :functions, :impact_faith_2, :performance_faith_2
    rename_column :functions, :impact_faith_3, :performance_faith_3
    rename_column :functions, :impact_faith_4, :performance_faith_4
    rename_column :functions, :impact_faith_5, :performance_faith_5
    rename_column :functions, :impact_faith_1, :confidence_information_faith_6
    rename_column :functions, :impact_faith_2, :confidence_information_faith_7
    rename_column :functions, :impact_faith_3, :confidence_information_faith_8
    rename_column :functions, :impact_faith_4, :confidence_information_faith_9
    rename_column :functions, :impact_faith_5, :confidence_information_faith_10
    
    rename_column :functions, :impact_race_1, :performance_race_1
    rename_column :functions, :impact_race_2, :performance_race_2
    rename_column :functions, :impact_race_3, :performance_race_3
    rename_column :functions, :impact_race_4, :performance_race_4
    rename_column :functions, :impact_race_5, :performance_race_5
    rename_column :functions, :impact_race_1, :confidence_information_race_6
    rename_column :functions, :impact_race_2, :confidence_information_race_7
    rename_column :functions, :impact_race_3, :confidence_information_race_8
    rename_column :functions, :impact_race_4, :confidence_information_race_9
    rename_column :functions, :impact_race_5, :confidence_information_race_10
    
    rename_column :functions, :impact_gender_1, :performance_gender_1
    rename_column :functions, :impact_gender_2, :performance_gender_2
    rename_column :functions, :impact_gender_3, :performance_gender_3
    rename_column :functions, :impact_gender_4, :performance_gender_4
    rename_column :functions, :impact_gender_5, :performance_gender_5
    rename_column :functions, :impact_gender_1, :confidence_information_gender_6
    rename_column :functions, :impact_gender_2, :confidence_information_gender_7
    rename_column :functions, :impact_gender_3, :confidence_information_gender_8
    rename_column :functions, :impact_gender_4, :confidence_information_gender_9
    rename_column :functions, :impact_gender_5, :confidence_information_gender_10
    
  end
end
