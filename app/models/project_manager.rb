class ProjectManager < User
  belongs_to :project

  def after_create
    self.update_attributes(:passkey => User.generate_passkey(self))
  end
end