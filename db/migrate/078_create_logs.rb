#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs, :force => true do |t|
      t.column :type,         :string
      t.column :message,      :string
      t.column :created_at,   :datetime
    end    
  end

  def self.down
    drop_table :logs
  end
end
