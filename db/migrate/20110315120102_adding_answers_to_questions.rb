class AddingAnswersToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :raw_answer, :text
    add_column :questions, :choices, :text
    add_column :questions, :help_text, :text
    add_column :questions, :label, :text
    add_column :questions, :input_type, :string
    add_column :questions, :section, :string
    add_column :questions, :strand, :string
    add_column :questions, :dependency_id, :integer
    
    create_table :dependencies do |t|
      t.integer :question_id
      t.integer :child_question_id
      t.integer :required_value
    end
    
   remove_column :activities, :purpose_overall_5
   remove_column :activities, :purpose_overall_6
   remove_column :activities, :purpose_overall_7
   remove_column :activities, :purpose_overall_8
   remove_column :activities, :purpose_overall_9
   remove_column :activities, :purpose_gender_3
   remove_column :activities, :purpose_race_3
   remove_column :activities, :purpose_disability_3
   remove_column :activities, :purpose_faith_3
   remove_column :activities, :purpose_sexual_orientation_3
   remove_column :activities, :purpose_age_3
   remove_column :activities, :purpose_gender_4
   remove_column :activities, :purpose_race_4
   remove_column :activities, :purpose_disability_4
   remove_column :activities, :purpose_faith_4
   remove_column :activities, :purpose_sexual_orientation_4
   remove_column :activities, :purpose_age_4
   remove_column :activities, :impact_gender_1
   remove_column :activities, :impact_gender_2
   remove_column :activities, :impact_gender_3
   remove_column :activities, :impact_gender_4
   remove_column :activities, :impact_gender_5
   remove_column :activities, :impact_race_1
   remove_column :activities, :impact_race_2
   remove_column :activities, :impact_race_3
   remove_column :activities, :impact_race_4
   remove_column :activities, :impact_race_5
   remove_column :activities, :impact_disability_1
   remove_column :activities, :impact_disability_2
   remove_column :activities, :impact_disability_3
   remove_column :activities, :impact_disability_4
   remove_column :activities, :impact_disability_5
   remove_column :activities, :impact_faith_1
   remove_column :activities, :impact_faith_2
   remove_column :activities, :impact_faith_3
   remove_column :activities, :impact_faith_4
   remove_column :activities, :impact_faith_5
   remove_column :activities, :impact_sexual_orientation_1
   remove_column :activities, :impact_sexual_orientation_2
   remove_column :activities, :impact_sexual_orientation_3
   remove_column :activities, :impact_sexual_orientation_4
   remove_column :activities, :impact_sexual_orientation_5
   remove_column :activities, :impact_age_1
   remove_column :activities, :impact_age_2
   remove_column :activities, :impact_age_3
   remove_column :activities, :impact_age_4
   remove_column :activities, :impact_age_5
   remove_column :activities, :impact_gender_6
   remove_column :activities, :impact_gender_7
   remove_column :activities, :impact_gender_8
   remove_column :activities, :impact_gender_9
   remove_column :activities, :impact_race_6
   remove_column :activities, :impact_race_7
   remove_column :activities, :impact_race_8
   remove_column :activities, :impact_race_9
   remove_column :activities, :impact_disability_6
   remove_column :activities, :impact_disability_7
   remove_column :activities, :impact_disability_8
   remove_column :activities, :impact_disability_9
   remove_column :activities, :impact_faith_6
   remove_column :activities, :impact_faith_7
   remove_column :activities, :impact_faith_8
   remove_column :activities, :impact_faith_9
   remove_column :activities, :impact_sexual_orientation_6
   remove_column :activities, :impact_sexual_orientation_7
   remove_column :activities, :impact_sexual_orientation_8
   remove_column :activities, :impact_sexual_orientation_9
   remove_column :activities, :impact_age_6
   remove_column :activities, :impact_age_7
   remove_column :activities, :impact_age_8
   remove_column :activities, :impact_age_9
   remove_column :activities, :consultation_gender_2
   remove_column :activities, :consultation_gender_3
   remove_column :activities, :consultation_gender_4
   remove_column :activities, :consultation_gender_5
   remove_column :activities, :consultation_gender_6
   remove_column :activities, :consultation_gender_7
   remove_column :activities, :consultation_race_1
   remove_column :activities, :consultation_race_2
   remove_column :activities, :consultation_race_3
   remove_column :activities, :consultation_race_4
   remove_column :activities, :consultation_race_5
   remove_column :activities, :consultation_race_6
   remove_column :activities, :consultation_race_7
   remove_column :activities, :consultation_disability_1
   remove_column :activities, :consultation_disability_2
   remove_column :activities, :consultation_disability_3
   remove_column :activities, :consultation_disability_4
   remove_column :activities, :consultation_disability_5
   remove_column :activities, :consultation_disability_6
   remove_column :activities, :consultation_disability_7
   remove_column :activities, :consultation_faith_1
   remove_column :activities, :consultation_faith_2
   remove_column :activities, :consultation_faith_3
   remove_column :activities, :consultation_faith_4
   remove_column :activities, :consultation_faith_5
   remove_column :activities, :consultation_faith_6
   remove_column :activities, :consultation_faith_7
   remove_column :activities, :consultation_sexual_orientation_1
   remove_column :activities, :consultation_sexual_orientation_2
   remove_column :activities, :consultation_sexual_orientation_3
   remove_column :activities, :consultation_sexual_orientation_4
   remove_column :activities, :consultation_sexual_orientation_5
   remove_column :activities, :consultation_sexual_orientation_6
   remove_column :activities, :consultation_sexual_orientation_7
   remove_column :activities, :consultation_age_1
   remove_column :activities, :consultation_age_2
   remove_column :activities, :consultation_age_3
   remove_column :activities, :consultation_age_4
   remove_column :activities, :consultation_age_5
   remove_column :activities, :consultation_age_6
   remove_column :activities, :consultation_age_7
   remove_column :activities, :purpose_overall_2
   remove_column :activities, :consultation_gender_1
   remove_column :activities, :additional_work_gender_1
   remove_column :activities, :additional_work_gender_2
   remove_column :activities, :additional_work_gender_3
   remove_column :activities, :additional_work_gender_4
   remove_column :activities, :additional_work_race_1
   remove_column :activities, :additional_work_race_2
   remove_column :activities, :additional_work_race_3
   remove_column :activities, :additional_work_race_4
   remove_column :activities, :additional_work_race_6
   remove_column :activities, :additional_work_disability_1
   remove_column :activities, :additional_work_disability_2
   remove_column :activities, :additional_work_disability_3
   remove_column :activities, :additional_work_disability_4
   remove_column :activities, :additional_work_disability_6
   remove_column :activities, :additional_work_disability_7
   remove_column :activities, :additional_work_sexual_orientation_1
   remove_column :activities, :additional_work_sexual_orientation_2
   remove_column :activities, :additional_work_sexual_orientation_3
   remove_column :activities, :additional_work_sexual_orientation_4
   remove_column :activities, :additional_work_sexual_orientation_6
   remove_column :activities, :additional_work_age_1
   remove_column :activities, :additional_work_age_2
   remove_column :activities, :additional_work_age_3
   remove_column :activities, :additional_work_age_4
   remove_column :activities, :additional_work_age_6
   remove_column :activities, :additional_work_faith_1
   remove_column :activities, :additional_work_faith_2
   remove_column :activities, :additional_work_faith_3
   remove_column :activities, :additional_work_faith_4
   remove_column :activities, :additional_work_faith_6
   remove_column :activities, :additional_work_disability_8
   remove_column :activities, :additional_work_disability_9
  end

  def self.down
    remove_column :questions, :raw_answer
    remove_column :questions, :choices
    remove_column :questions, :help_text
    remove_column :questions, :label
    remove_column :questions, :input_type 
    
    drop_table :dependencies
  end
end
