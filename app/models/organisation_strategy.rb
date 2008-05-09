class OrganisationStrategy < Strategy
  belongs_to :organisation
  attr_accessor :should_destroy
  acts_as_list :scope => :organisation

  def should_destroy?
    should_destroy.to_i == 1
  end

end
