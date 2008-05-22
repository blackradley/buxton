#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
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
