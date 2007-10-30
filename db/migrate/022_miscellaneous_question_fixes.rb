#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserve 
#
class MiscellaneousQuestionFixes < ActiveRecord::Migration
  def self.up
	add_column :functions, :additional_work_disability_13,  :integer,  :default => 0
	add_column :functions, :additional_work_disability_14,  :integer,  :default => 0
	
	remove_column :functions, :additional_work_gender_11
  end

  def self.down
	remove_column :functions, :additional_work_disability_13
	remove_column :functions, :additional_work_disability_13
	
	add_column :functions, :additional_work_gender_11,  :integer,  :default => 0
  end
end
