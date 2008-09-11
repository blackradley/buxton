class AlterActivitiesTableEngine < ActiveRecord::Migration
  def self.up
    execute('ALTER TABLE activities ENGINE = MyISAM')
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
