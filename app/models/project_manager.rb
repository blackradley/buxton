class ProjectManager < User
  belongs_to :project
  delegate :organisation, :organisation=, :to => :project
  delegate :activities, :to => :project    
end