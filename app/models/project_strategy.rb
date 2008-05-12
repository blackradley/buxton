class ProjectStrategy < Strategy
  belongs_to :project
  attr_accessor :should_destroy
  acts_as_list :scope => :project

  def should_destroy?
    should_destroy.to_i == 1
  end

end