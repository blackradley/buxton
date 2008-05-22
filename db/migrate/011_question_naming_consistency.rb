#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class QuestionNamingConsistency < ActiveRecord::Migration
  def self.up
    rename_column :functions, :sexual_validation_regime, :sexual_orientation_validation_regime
    rename_column :functions, :sexual_note_issues, :sexual_orientation_note_issues
  end

  def self.down
    rename_column :functions, :sexual_orientation_validation_regime, :sexual_validation_regime
    rename_column :functions, :sexual_orientation_note_issues, :sexual_note_issues
  end
end
