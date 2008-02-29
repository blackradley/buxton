class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs, :force => true do |t|
      t.column :type,         :string
      t.column :message,      :string
      t.column :created_at,   :datetime
    end    
  end

  def self.down
    drop_table :logs
  end
end
