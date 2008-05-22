#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class RemoveDirectorateTerm < ActiveRecord::Migration
  def self.up
    remove_column :organisations, :directorate_term
  end

  def self.down
    add_column :organisations, :directorate_term, :string
  end
end
