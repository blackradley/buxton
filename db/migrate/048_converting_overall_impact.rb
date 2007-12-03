class ConvertingOverallImpact < ActiveRecord::Migration
  def self.up
    rename_column :functions, :performance_overall_1, :impact_overall_1
    rename_column :functions, :performance_overall_2, :impact_overall_2
    rename_column :functions, :performance_overall_3, :impact_overall_3
    rename_column :functions, :performance_overall_4, :impact_overall_4
    rename_column :functions, :performance_overall_5, :impact_overall_5
    rename_column :functions, :confidence_information_overall_1, :impact_overall_6
    rename_column :functions, :confidence_information_overall_2, :impact_overall_7
    rename_column :functions, :confidence_information_overall_3, :impact_overall_8
    rename_column :functions, :confidence_information_overall_4, :impact_overall_9
    rename_column :functions, :confidence_information_overall_5, :impact_overall_10
  end

  def self.down

    rename_column :functions, :impact_overall_1, :performance_overall_1
    rename_column :functions, :impact_overall_2, :performance_overall_2
    rename_column :functions, :impact_overall_3, :performance_overall_3
    rename_column :functions, :impact_overall_4, :performance_overall_4
    rename_column :functions, :impact_overall_5, :performance_overall_5
    rename_column :functions, :impact_overall_1, :confidence_information_overall_6
    rename_column :functions, :impact_overall_2, :confidence_information_overall_7
    rename_column :functions, :impact_overall_3, :confidence_information_overall_8
    rename_column :functions, :impact_overall_4, :confidence_information_overall_9
    rename_column :functions, :impact_overall_5, :confidence_information_overall_10
    
  end
end
