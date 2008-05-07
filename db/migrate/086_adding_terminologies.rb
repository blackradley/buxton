class AddingTerminologies < ActiveRecord::Migration

  def self.up
    Terminology.new(:term => 'strategy').save
    Terminology.new(:term => 'corporate equality scheme').save
  end

  def self.down
    #Terminology.find_by_term('strategy').destroy
    #Terminology.find_by_term('corporate equality scheme').destroy
  end
end
