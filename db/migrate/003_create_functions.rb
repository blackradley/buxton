#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
#
class CreateFunctions < ActiveRecord::Migration
  def self.up
    create_table :functions, :force => true do |t|
      t.column :user_id,          :integer
      t.column :organisation_id,  :integer
      t.column :name,             :string
      t.column :relevance01,      :integer
      t.column :relevance02,      :integer
      t.column :relevance03,      :integer
      t.column :is_approved,      :boolean
      t.column :created_on,       :timestamp
      t.column :updated_on,       :timestamp
      t.column :deleted_on,       :timestamp
    end
  end

  def self.down
    drop_table :functions
  end
end
