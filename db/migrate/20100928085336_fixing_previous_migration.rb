class FixingPreviousMigration < ActiveRecord::Migration
  def self.up
    outdated_ids = [513042287, 513042288, 513042289, 513042290, 513042291]
    puts "Deleting activity strategies for outdated ids"
    outdated_ids.map{|id| ActivityStrategy.find_all_by_strategy_id(id)}.flatten.map(&:destroy)
  end
end
