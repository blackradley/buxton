class Dependency < ActiveRecord::Base
  attr_protected
  belongs_to :question
  has_one :child_question, :class_name => "Question"

  def satisfied?
    question.response.to_i == required_value
  end

  def as_json
    {child_question.name => required_value}
  end

end
