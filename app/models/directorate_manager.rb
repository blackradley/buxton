class DirectorateManager < User
  # The user controls a directorate.
  belongs_to :directorate
  # delegate :organisation, :organisation=, to => :directorate

  def after_create
    self.update_attributes(:passkey => User.generate_passkey(self))
  end
end
