#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
class CreateOrganisations < ActiveRecord::Migration
  def self.up
    create_table :organisations, :force => true do |t|
      t.column :user_id,                          :integer
      t.column :name,                             :string
      t.column :style,                            :string,  :default => 'www'
      t.column :strategies_description,           :string,  :default => 'Which of the priorities (below) are you helping to deliver?'
      t.column :strategies_help,                  :text
      t.column :impact_groups_description,        :string,  :default => 'Which of these groups are you having an impact on?'
      t.column :impact_groups_help,               :text
      t.column :good_equality_groups_description, :string,  :default => 'Positive differential impact'
      t.column :good_equality_groups_help,        :text
      t.column :bad_equality_groups_description,  :string,  :default => 'Negative differential impact'
      t.column :bad_equality_groups_help,         :text
      t.column :approval_help,                    :text
      t.column :created_on,                       :timestamp
      t.column :updated_on,                       :timestamp
      t.column :deleted_on,                       :timestamp
    end
  end

  def self.down
    drop_table :organisations
  end
end
