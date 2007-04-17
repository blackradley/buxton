#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
#
class CreateFunctions < ActiveRecord::Migration
  def self.up
    create_table :functions, :force => true do |t|
      t.column :user_id,           :integer
      t.column :organisation_id,   :integer
      t.column :name,              :string
      t.column :relevance01,       :integer
      t.column :relevance02,       :integer
      t.column :relevance03,       :integer
      t.column :relevance04,       :integer
      t.column :relevance05,       :integer
      t.column :relevance06,       :integer
      t.column :relevance07,       :integer
      t.column :relevance08,       :integer
      t.column :relevance09,       :integer
      t.column :relevance10,       :integer
      t.column :relevance11,       :integer
      t.column :relevance12,       :integer
      t.column :relevance13,       :integer
      t.column :relevance14,       :integer
      t.column :relevance15,       :integer
      t.column :relevance16,       :integer
      t.column :relevance17,       :integer
      t.column :relevance18,       :integer
      t.column :relevance19,       :integer
      t.column :relevance20,       :integer
      t.column :is_approved,       :boolean
      t.column :created_on,        :timestamp
      t.column :updated_on,        :timestamp
      t.column :deleted_on,        :timestamp
    end
  end

  def self.down
    drop_table :functions
  end
end
