module ActivityManager
  def activity_manager_activities
    Activity.where(:activity_manager_id => self.id)
  end
  
  
end