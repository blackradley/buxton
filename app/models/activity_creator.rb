class ActivityCreator < User
  # The user creates an activity.
  belongs_to :organisation
  
  def before_create
    self.passkey = ActivityCreator.generate_passkey(self) unless self.passkey
  end
end
