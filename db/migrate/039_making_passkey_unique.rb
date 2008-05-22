#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class MakingPasskeyUnique < ActiveRecord::Migration
  def self.up
	change_column :users, :passkey, :string, :unique => true
  end

  def self.down
	 change_column :users, :passkey, :string, :unique => false 
  end
end
