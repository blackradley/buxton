module ActivityApprover
  def activity_approver_activities
    self.activities.find_all_by_activity_manager_id(self.id)
  end

end