class CreateOrganisations < ActiveRecord::Migration
  def self.up
    ActiveRecord::Schema.define do
      create_table "organisations", :force => true do |t|
        t.column "key",        :string,    :limit => 128,  :null => true
        t.column "email",      :string,    :limit => 256,  :null => true
        t.column "name",       :string,    :limit => 256,  :null => true
        t.column "style",      :string,    :limit => 256,  :null => true
        t.column "created_on", :timestamp
        t.column "updated_on", :timestamp
      end
    end
  end

  def self.down
    drop_table :organisations
  end
end
