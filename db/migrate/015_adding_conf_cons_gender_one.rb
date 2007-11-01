#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class AddingConfConsGenderOne < ActiveRecord::Migration
  def self.up
	add_column :functions, :confidence_consultation_gender_1, :integer, :default => 0
  end

  def self.down
	remove_column :functions, :confidence_consultation_gender_1, :integer, :default => 0	
  end
end
