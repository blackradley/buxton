class ChangeRegimeToString < ActiveRecord::Migration
  def self.up
    change_column :functions, :overall_validation_regime, :string
    change_column :functions, :gender_validation_regime, :string
    change_column :functions, :race_validation_regime, :string
    change_column :functions, :disability_validation_regime, :string
    change_column :functions, :faith_validation_regime, :string
    change_column :functions, :sexual_validation_regime, :string
    change_column :functions, :age_validation_regime, :string
  end

  def self.down
    change_column :functions, :overall_validation_regime, :text
    change_column :functions, :gender_validation_regime, :text
    change_column :functions, :race_validation_regime, :text
    change_column :functions, :disability_validation_regime, :text
    change_column :functions, :faith_validation_regime, :text
    change_column :functions, :sexual_validation_regime, :text
    change_column :functions, :age_validation_regime, :text
  end
end
