class RenameMoreAdditionalWork < ActiveRecord::Migration
  def self.up
	rename_column :functions, :additional_work_race_10, :additional_work_race_6
	rename_column :functions, :additional_work_race_11, :additional_work_race_7		

	rename_column :functions, :additional_work_faith_10, :additional_work_faith_6
	rename_column :functions, :additional_work_faith_11, :additional_work_faith_7
	
	rename_column :functions, :additional_work_sexual_orientation_10, :additional_work_sexual_orientation_6
	rename_column :functions, :additional_work_sexual_orientation_11, :additional_work_sexual_orientation_7

	rename_column :functions, :additional_work_age_10, :additional_work_age_6
	rename_column :functions, :additional_work_age_11, :additional_work_age_7
	
	rename_column :functions, :additional_work_gender_10, :additional_work_gender_6
  end

  def self.down
	rename_column :functions, :additional_work_race_6, :additional_work_race_10
	rename_column :functions, :additional_work_race_7, :additional_work_race_11		

	rename_column :functions, :additional_work_faith_6, :additional_work_faith_10
	rename_column :functions, :additional_work_faith_7, :additional_work_faith_11
	
	rename_column :functions, :additional_work_sexual_orientation_6, :additional_work_sexual_orientation_10
	rename_column :functions, :additional_work_sexual_orientation_7, :additional_work_sexual_orientation_11

	rename_column :functions, :additional_work_age_6, :additional_work_age_10
	rename_column :functions, :additional_work_age_7, :additional_work_age_11
	
	rename_column :functions, :additional_work_gender_6, :additional_work_gender_10
  end
end
