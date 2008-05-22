#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class DateDateToString < ActiveRecord::Migration
  def self.up
    change_column :activities, :review_on, :string
  end

  def self.down
    change_column :activities, :review_on, :date
  end
end
