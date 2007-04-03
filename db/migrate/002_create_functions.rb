class CreateFunctions < ActiveRecord::Migration
  def self.up
    create_table :functions, :force => true do |t|
      t.column "key",             :string,    :limit => 128, :null => true
      t.column "email",           :string,    :limit => 256, :null => true
      t.column "name",            :string,    :limit => 256, :null => true
      t.column "organisation_id", :integer,   :limit => 2,   :null => true
      t.column "relevance01",     :integer,   :limit => 2,   :null => true
      t.column "relevance02",     :integer,   :limit => 2,   :null => true
      t.column "relevance03",     :integer,   :limit => 2,   :null => true
      t.column "relevance04",     :integer,   :limit => 2,   :null => true
      t.column "relevance05",     :integer,   :limit => 2,   :null => true
      t.column "relevance06",     :integer,   :limit => 2,   :null => true
      t.column "relevance07",     :integer,   :limit => 2,   :null => true
      t.column "relevance08",     :integer,   :limit => 2,   :null => true
      t.column "relevance09",     :integer,   :limit => 2,   :null => true
      t.column "relevance10",     :integer,   :limit => 2,   :null => true
      t.column "created_on",      :timestamp
      t.column "updated_on",      :timestamp
    end
  end

  def self.down
    drop_table :functions
  end
end
