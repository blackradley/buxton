class CreateFunctions < ActiveRecord::Migration
  def self.up
    create_table "functions", :force => true do |t|
      t.column "key",             :string,    :limit => 36,  :default => "", :null => false
      t.column "email",           :string,    :limit => 256, :default => "", :null => false
      t.column "name",            :string,    :limit => 256, :default => "", :null => false
      t.column "organisation_id", :integer,   :limit => 10,                  :null => false
      t.column "relevance01",     :integer,   :limit => 10,  :default => 1, :null => false
      t.column "relevance02",     :integer,   :limit => 10,  :default => 1, :null => false
      t.column "relevance03",     :integer,   :limit => 10,  :default => 1, :null => false
      t.column "relevance04",     :integer,   :limit => 10,  :default => 1, :null => false
      t.column "relevance05",     :integer,   :limit => 10,  :default => 1, :null => false
      t.column "relevance06",     :integer,   :limit => 10,  :default => 1, :null => false
      t.column "relevance07",     :integer,   :limit => 10,  :default => 1, :null => false
      t.column "relevance08",     :integer,   :limit => 10,  :default => 1, :null => false
      t.column "relevance09",     :integer,   :limit => 10,  :default => 1, :null => false
      t.column "relevance10",     :integer,   :limit => 10,  :default => 1, :null => false
      t.column "created_on",      :timestamp
      t.column "updated_on",      :timestamp
    end
  end

  def self.down
    drop_table :functions
  end
end
