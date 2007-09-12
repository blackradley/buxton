class PerformanceFields < ActiveRecord::Migration
  def self.up
    add_column :functions, :overall_performance, :integer,  :default => 0
    add_column :functions, :overall_validated, :integer,  :default => 0
    add_column :functions, :overall_validation_regime, :text
    add_column :functions, :overall_issues, :integer,  :default => 0
    add_column :functions, :overall_note_issues, :text

    add_column :functions, :gender_performance, :integer,  :default => 0
    add_column :functions, :gender_validated, :integer,  :default => 0
    add_column :functions, :gender_validation_regime, :text
    add_column :functions, :gender_issues, :integer,  :default => 0
    add_column :functions, :gender_note_issues, :text

    add_column :functions, :race_performance, :integer,  :default => 0
    add_column :functions, :race_validated, :integer,  :default => 0
    add_column :functions, :race_validation_regime, :text
    add_column :functions, :race_issues, :integer,  :default => 0
    add_column :functions, :race_note_issues, :text

    add_column :functions, :disability_performance, :integer,  :default => 0
    add_column :functions, :disability_validated, :integer,  :default => 0
    add_column :functions, :disability_validation_regime, :text
    add_column :functions, :disability_issues, :integer,  :default => 0
    add_column :functions, :disability_note_issues, :text

    add_column :functions, :faith_performance, :integer,  :default => 0
    add_column :functions, :faith_validated, :integer,  :default => 0
    add_column :functions, :faith_validation_regime, :text
    add_column :functions, :faith_issues, :integer,  :default => 0
    add_column :functions, :faith_note_issues, :text

    add_column :functions, :sexual_orientation_performance, :integer,  :default => 0
    add_column :functions, :sexual_orientation_validated, :integer,  :default => 0
    add_column :functions, :sexual_validation_regime, :text
    add_column :functions, :sexual_orientation_issues, :integer,  :default => 0
    add_column :functions, :sexual_note_issues, :text

    add_column :functions, :age_performance, :integer,  :default => 0
    add_column :functions, :age_validated, :integer,  :default => 0
    add_column :functions, :age_validation_regime, :text
    add_column :functions, :age_issues, :integer,  :default => 0
    add_column :functions, :age_note_issues, :text
  end

  def self.down
    remove_column :functions, :overall_performance
    remove_column :functions, :overall_validated
    remove_column :functions, :overall_validation_regime
    remove_column :functions, :overall_issues
    remove_column :functions, :overall_note_issues

    remove_column :functions, :gender_performance
    remove_column :functions, :gender_validated
    remove_column :functions, :gender_validation_regime
    remove_column :functions, :gender_issues
    remove_column :functions, :gender_note_issues

    remove_column :functions, :race_performance
    remove_column :functions, :race_validated
    remove_column :functions, :race_validation_regime
    remove_column :functions, :race_issues
    remove_column :functions, :race_note_issues

    remove_column :functions, :disability_performance
    remove_column :functions, :disability_validated
    remove_column :functions, :disability_validation_regime
    remove_column :functions, :disability_issues
    remove_column :functions, :disability_note_issues

    remove_column :functions, :faith_performance
    remove_column :functions, :faith_validated
    remove_column :functions, :faith_validation_regime
    remove_column :functions, :faith_issues
    remove_column :functions, :faith_note_issues

    remove_column :functions, :sexual_orientation_performance
    remove_column :functions, :sexual_orientation_validated
    remove_column :functions, :sexual_validation_regime
    remove_column :functions, :sexual_orientation_issues
    remove_column :functions, :sexual_note_issues

    remove_column :functions, :age_performance
    remove_column :functions, :age_validated
    remove_column :functions, :age_validation_regime
    remove_column :functions, :age_issues
    remove_column :functions, :age_note_issues    
  end
end
