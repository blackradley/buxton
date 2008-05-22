#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
namespace :db do
  desc "Reload every activity so that the completed tags and statistics are brought up to date with the new functions"
  task :resync => :environment do
    Activity.find(:all).each do |activity|
      puts '------------------------'
      puts "start #{activity.name} syncing."
      puts 'retrieving comments'
      #Activity strategies will take their comments with them when they are moved across.
      comments = Hash[*activity.questions.map{|question| [question.name, question.comment]}.flatten]
      puts 'retrieving notes'
      notes = Hash[*activity.questions.map{|question| [question.name, question.note]}.flatten]
      puts 'retrieving activity_strategies'
      activity_strategies = activity.activity_strategies
      puts 'retrieving issues'
      issues = activity.issues
      puts 'retrieving activity manager'
      act_man = activity.activity_manager
      puts 'destroying old activity'
      act_man.destroy
      activity.destroy
      puts 'constructing new activity'
      question_names = Activity.get_question_names
      questions = Hash[*question_names.map{|question| [question.to_sym, activity.attributes[question.to_s]]}.flatten]
      existing_proposed = activity.attributes['existing_proposed']
      function_policy = activity.attributes['function_policy']
      ces_question = activity.attributes['ces_question']
      non_questions = activity.attributes.delete_if do |attribute, value|
        (question_names.include? attribute.to_sym || attribute == 'existing_proposed' || attribute == 'function_policy')
      end
      new_activity = Activity.new(non_questions)
      act_man_to_nuke = new_activity.build_activity_manager(:email => 'temporay@email.com')
      act_man_to_nuke.passkey = ActivityManager.generate_passkey(act_man_to_nuke)
      act_man_to_nuke.save!
      new_activity.save!
      puts 'restoring elements:'
      puts 'restoring questions'
      new_activity.update_attributes!(:existing_proposed => existing_proposed, :function_policy => function_policy)
      new_activity.saved = nil
      new_activity.update_attributes!(:ces_question => ces_question)
      new_activity.saved = nil
      new_activity.update_attributes!(questions)
      puts 'restoring activity_strategies'
      activity_strategies.clone.each do |activity_strategy|
        old_attributes = activity_strategy.attributes
        old_attributes.delete('activity_id')
        new_act_strat = new_activity.activity_strategies.build(old_attributes)
        new_act_strat.save
      end
      puts 'restoring issues'
      issues.clone.each do |issue|
        old_attributes = issue.attributes
        old_attributes.delete('activity_id')
        new_issue = new_activity.issues.build(old_attributes)
        new_issue.save
      end
      puts 'restoring comments'
      comments.each do |question_name, comment|
        next if comment.nil?
        comment_att = comment.attributes
        comment_att.delete(:question_id)
        new_comment = new_activity.questions.find_by_name(question_name).build_comment(comment_att)
        new_comment.save!
      end
      puts 'restoring notes'
      notes.each do |question_name, note|
        next if note.nil?
        note_att = note.attributes
        note_att.delete(:question_id)
        new_note = new_activity.questions.find_by_name(question_name).build_note(note_att)
        new_note.save!
      end
      puts 'restoring activity manager'
      act_man_att = act_man.attributes
      act_man_att.delete(:activity_id)
      act_man_to_nuke.update_attributes!(act_man_att)
      new_activity.save!
      puts "#{activity.name} synced."
    end
  end
end
