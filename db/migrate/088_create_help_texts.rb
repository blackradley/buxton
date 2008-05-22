#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class CreateHelpTexts < ActiveRecord::Migration
  def self.up
    create_table :help_texts do |t|
      t.text :question_name
      t.text :existing_function
      t.text :existing_policy
      t.text :proposed_function
      t.text :proposed_policy
      t.timestamps
    end
  end

  def self.down
    drop_table :help_texts
  end
end
