#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class AddingCesCustomText < ActiveRecord::Migration
  def self.up
    add_column :organisations, :ces_term, :string, :default => "Corporate Equality Scheme"
  end

  def self.down
    remove_column :organisations, :ces_term
  end
end
