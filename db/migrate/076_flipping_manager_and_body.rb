#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class FlippingManagerAndBody < ActiveRecord::Migration
  def self.up
    # activity_pairings = Activity.find(:all).reject{|a| a.activity_manager_id.blank?}
    # activity_pairings.map!{|activity| [ActivityManager.find(activity.activity_manager_id), activity]}
    # activity_pairings.reject!{|actman, act| act.nil? || actman.nil?}
    add_column :users, :activity_id, :integer
    # activity_pairings.map!{|actman, act| [ActivityManager.find(actman.id), Activity.find(act.id)]} #Model needs to be reinitialised to include new column
    # activity_pairings.each do |activity_manager, activity|
    #   activity_manager.update_attributes(:activity_id => activity.id)
    # end
    remove_column :activities, :activity_manager_id
    
    # organisation_pairings = Organisation.find(:all).reject{|o| o.organisation_manager_id.blank?}
    # organisation_pairings.map!{|organisation| [OrganisationManager.find(organisation.organisation_manager_id), organisation]}
    # organisation_pairings.reject!{|orgman, org| org.nil? || orgman.nil?}
    add_column :users, :organisation_id, :integer
    # organisation_pairings.map!{|orgman, org| [OrganisationManager.find(orgman.id), Organisation.find(org.id)]}
    # organisation_pairings.each do |organisation_manager, organisation|
    #   organisation_manager.update_attributes(:organisation_id => organisation.id)
    # end
    remove_column :organisations, :organisation_manager_id   
  end

  def self.down
    #warning. Self.down badly borked, it will appear to work, but in fact disassociates all managers with bodies. Do not use.
    # organisation_pairings = OrganisationManager.find(:all).reject{|o| o.organisation_id.blank?}
    # organisation_pairings.map!{|orgman| [orgman, Organisation.find(orgman.organisation_id)]}
    # organisation_pairings.reject!{|orgman, org| org.nil? || orgman.nil?}
    add_column :organisations, :organisation_manager_id, :integer
    # organisation_pairings.map!{|orgman, org| [OrganisationManager.find(orgman.id), Organisation.find(org.id)]}
    # organisation_pairings.each do |organisation_manager, organisation|
    #   organisation.update_attributes(:organisation_manager_id => organisation_manager.id)
    # end
    remove_column :users, :organisation_id
    
    # activity_pairings = ActivityManager.find(:all).reject{|a| a.activity_id.blank?}
    # activity_pairings.map!{|actman| [actman, Activity.find(actman.activity_id)]}
    # activity_pairings.reject!{|actman, act| act.nil? || actman.nil?}
    add_column :activities, :activity_manager_id, :integer
    # activity_pairings.map!{|actman, act| [ActivityManager.find(actman.id), Activity.find(act.id)]}
    # activity_pairings.each do |activity_manager, activity|
    #   activity.update_attributes(:activity_manager_id => activity_manager.id)
    # end
    remove_column :users, :activity_id
  end
end
