#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :question_id
      t.text :contents
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
