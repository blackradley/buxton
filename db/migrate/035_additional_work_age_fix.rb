#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserve 
#
class AdditionalWorkAgeFix < ActiveRecord::Migration
  def self.up
	remove_column :functions, :additional_work_age_1
	remove_column :functions, :additional_work_age_2
	remove_column :functions, :additional_work_age_3
	remove_column :functions, :additional_work_age_4
  end

  def self.down
	add_column :functions, :additional_work_age_1, :text
	add_column :functions, :additional_work_age_2, :text
	add_column :functions, :additional_work_age_3, :text
	add_column :functions, :additional_work_age_4, :text
	
  end
end
