class DirectorateManager < User
  # The user controls a directorate.
  belongs_to :directorate
  delegate :organisation, :organisation=, :to => :directorate
end
