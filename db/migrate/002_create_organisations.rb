#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
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
      t.column :good_equality_groups_description, :string,  :default => 'If the function were performed well...'
      t.column :good_equality_groups_help,        :text
      t.column :bad_equality_groups_description,  :string,  :default => 'If the function were performed badly...'
      t.column :bad_equality_groups_help,         :text
      t.column :approval_help,                    :text
      t.column :created_on,                       :timestamp
      t.column :updated_on,                       :timestamp
      t.column :deleted_on,                       :timestamp
    end
    
    # Create birmingham as an organisation attached to 
    # Birmingham user
    organisational_user = User.create(:user_type => User::TYPE[:organisational],
      :email => 'Peter_Latchford@blackradley.com')
    Organisation.create(:user_id => organisational_user.id,
    :name => 'Birmingham City Council',
    :style => 'birmingham',
    :strategies_help => 'Help for Birmingham strategies required',
    :impact_groups_help => 'Help for Birmingham impact groups required',
    :good_equality_groups_help => 'Help for Birmingham good equality groups required',
    :bad_equality_groups_help => 'Help for Birmingham bad equality groups required',
    :approval_help => 'Help for Birmingham approval required')
  end

  def self.down
    drop_table :organisations
  end
end
