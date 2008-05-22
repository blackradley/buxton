#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class RemovingOldTerminologiesAndReAddingThem < ActiveRecord::Migration
  def self.up
    Terminology.find(:all).each{|t| t.destroy}
    add_seed :terminology, :term => 'strategy'
    add_seed :terminology, :term => 'corporate equality scheme'
    add_seed :terminology, :term => 'directorate'
    add_seed :terminology, :term => 'project'
  end

  def self.down
    remove_seed :terminology, :term => 'strategy'
    remove_seed :terminology, :term => 'corporate equality scheme'
    remove_seed :terminology, :term => 'directorate'
    remove_seed :terminology, :term => 'project'  
  end
end
