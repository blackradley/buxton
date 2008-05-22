#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class CreateTerminologies < ActiveRecord::Migration
  def self.up
    create_table :terminologies do |t|
      t.string :term, :default => ''
      t.timestamps
    end
  end

  def self.down
    drop_table :terminologies
  end
end
