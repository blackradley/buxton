class CreateOrganisations < ActiveRecord::Migration
  def self.up
    #ActiveRecord::Schema.define(:version => 0) do
      create_table "organisations", :force => true do |t|
        t.column "key",        :string,    :limit => 36,  :default => "", :null => false
        t.column "email",      :string,    :limit => 256, :default => "", :null => false
        t.column "name",       :string,    :limit => 256, :default => "", :null => false
        t.column "style",      :string,    :limit => 256, :default => "", :null => false
        t.column "created_on", :timestamp
        t.column "updated_on", :timestamp
      end
   # end
  end

  def self.down
    drop_table :organisations
  end
end
