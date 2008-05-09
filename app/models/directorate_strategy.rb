class DirectorateStrategy < Strategy
  belongs_to :directorate
  attr_accessor :should_destroy
  acts_as_list :scope => :directorate

  def should_destroy?
    should_destroy.to_i == 1
  end

end