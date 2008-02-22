#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
namespace :db do
  desc "Reload every question in every activity so that the completed tags and statistics are brought up to date with the new functions"
  task :resync => :environment do
  Activity.find(:all).each do |activity|
    activity.saved = nil
    activity_clone = activity.clone
    blank_question_names = Activity.get_question_names.map{|name| {name => 0}}
    blank_question_names_hash = {}
    blank_question_names.each{|name| blank_question_names_hash.merge!(name)}
    blank_question_names_hash.delete(:existing_proposed)
    blank_question_names_hash.delete(:function_policy)
    activity.update_attributes!(blank_question_names_hash)
    activity.saved = nil
    activity.update_attributes(:gender_percentage_importance => 0, :disability_percentage_importance => 0, :race_percentage_importance => 0, :age_percentage_importance => 0, :faith_percentage_importance => 0, :sexual_orientation_percentage_importance => 0, :impact => 0)
    activity.saved = nil
    restore_data_hash = {}
    blank_question_names_hash.keys.each{|q| restore_data_hash[q] = activity_clone.send(q)}
    restore_data_hash.delete(:existing_proposed)
    restore_data_hash.delete(:function_policy)
    activity.update_attributes(restore_data_hash)
    activity.saved = nil
    activity.update_attributes(:existing_proposed => activity_clone.existing_proposed, :function_policy => activity_clone.function_policy)
    activity.saved = nil
  end
  end
end
