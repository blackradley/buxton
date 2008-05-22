#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class MovingCesQuestion < ActiveRecord::Migration
  def self.up
    rename_column :activities, :purpose_overall_10, :ces_question
  end

  def self.down
    rename_column :activities, :ces_question, :purpose_overall_10
  end
end
