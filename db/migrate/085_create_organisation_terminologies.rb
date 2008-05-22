#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class CreateOrganisationTerminologies < ActiveRecord::Migration
  def self.up
    create_table :organisation_terminologies do |t|
      t.integer :organisation_id
      t.integer :terminology_id
      t.string :value, :default => ''
      t.timestamps
    end
  end

  def self.down
    drop_table :organisation_terminologies
  end
end
