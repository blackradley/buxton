namespace :clone do
  desc 'Clone an activity and its associations'
  task :activity => :environment do
    #TODO: Get activity to be cloned
    if id = ENV['ID']
      activity = Activity.find(id)
    elsif name = ENV['NAME']
      activity = Activity.find_by_name(name)
    else
      puts 'No activity specified. Usage: rake ID=5 clone:activity or rake NAME="sample activity" clone:activity'
      return
    end
    new_act = activity.clone
    new_act.send(:create_without_callbacks)
    [:issues, :questions, :activity_strategies, :activity_manager, :activity_approver].each do |assoc|
      model = activity.send(assoc)
      next unless model
      if model.is_a?(Array)
        model.each do |item|
          clone = item.clone
          clone.activity_id = new_act.id
          clone.save!
          if [:questions, :activity_strategies].include?(assoc)
            [:comment, :note].each do |text|
              text_item = item.send(text)
              next unless text_item
              text_clone = text_item.clone
              text_item.question_id ? (text_clone.question_id = clone.id) : (text_clone.activity_strategy_id = clone.id)
              text_clone.save!
            end
          end
        end
      else
        clone = model.clone
        clone.activity_id = new_act.id
        clone.save!
      end
    end
    
    
    new_act.projects = activity.projects
    new_act.save!
  end
end