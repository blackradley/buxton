#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class AddCesLink < ActiveRecord::Migration
  def self.up
  	add_column :organisations, :ces_link, :string
  end

  def self.down
  	remove_column :organisations, :ces_link, :string
  end
end
