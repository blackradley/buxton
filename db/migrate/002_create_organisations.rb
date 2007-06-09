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
      t.column :style,                            :string
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
    
    # Create birmingham as an organisation attached to 
    birmingham_user = User.find(:first, 
      :conditions => "email = 'Peter_Latchford@blackradley.com' AND user_type = '#{User::TYPE[:organisational]}'")
    Organisation.create(:user_id => birmingham_user.id,
    :name => 'Birmingham City Council',
    :style => 'birmingham',
    :strategies_help => '',
    :impact_groups_help => '',
    :good_equality_groups_help => '',
    :bad_equality_groups_help => '',
    :approval_help => '')
  end

  def self.down
    drop_table :organisations
  end
end
