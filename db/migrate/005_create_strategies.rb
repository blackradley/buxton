#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserve
#
class CreateStrategies < ActiveRecord::Migration
  def self.up
    create_table :strategies, :force => true do |t|
      t.column :organisation_id, :integer
      t.column :name,            :string
      t.column :description,     :string
      t.column :display_order,   :integer  
      t.column :created_on,      :timestamp
      t.column :updated_on,      :timestamp    
    end
    
    birmingham = Organisation.find(:first, :conditions => "style = 'birmingham'")
    Strategy.create(:organisation_id => birmingham.id,
      :name => 'Manage resources effectively, flexibly and responsively',
      :description => 'Manage resources effectively, flexibly and responsively',
      :display_order => 0)
    Strategy.create(:organisation_id => birmingham.id,
      :name => 'Investing in our staff to build an organisation that is fit for its purpose',
      :description => 'Investing in our staff to build an organisation that is fit for its purpose',
      :display_order => 1)
    Strategy.create(:organisation_id => birmingham.id,
      :name => 'Raising performance in our services for children, young people, families and adult',
      :description => 'Raising performance in our services for children, young people, families and adult',
      :display_order => 2)
    Strategy.create(:organisation_id => birmingham.id,
      :name => 'Raising performance in our housing services',
      :description => 'Raising performance in our housing services',
      :display_order => 3)
    Strategy.create(:organisation_id => birmingham.id,
      :name => 'Cleaner, greener and safer city – Your City, Your Birmingham',
      :description => 'Cleaner, greener and safer city – Your City, Your Birmingham',
      :display_order => 4)
    Strategy.create(:organisation_id => birmingham.id,
      :name => 'Investing in regeneration',
      :description => 'Investing in regeneration',
      :display_order => 5)
    Strategy.create(:organisation_id => birmingham.id,
      :name => "Improving the city's transport and tackling congestion",
      :description => "Improving the city's transport and tackling congestion",
      :display_order => 6)
    Strategy.create(:organisation_id => birmingham.id,
      :name => 'A fair and welcoming city',
      :description => 'A fair and welcoming city',
      :display_order => 7)
    Strategy.create(:organisation_id => birmingham.id,
      :name => 'Providing more effective education and leisure opportunities',
      :description => 'Providing more effective education and leisure opportunities',
      :display_order => 8)
    Strategy.create(:organisation_id => birmingham.id,
      :name => 'Promoting Birmingham as a great international city',
      :description => 'Promoting Birmingham as a great international city',
      :display_order => 9)
  end

  def self.down
    drop_table :strategies
  end
end
