class Question < ActiveRecord::Base
  belongs_to :activity
  has_one :comment, :dependent => :destroy
  has_one :note, :dependent => :destroy
  validates_uniqueness_of :name, :scope => :activity_id
  attr_reader :section, :strand, :number
  def weights
    [*@@Hashes['weights'][self.activity.question_wording_lookup(section, strand, number)[4]]].map(&:to_i)
  end

  def weight
    weights[self.response.to_i]
  end

  def invisible?
    (!@@invisible_questions.include?(self.name) && self.activity.existing_proposed == 2)
  end

  def response
    self.activity.send(self.name)
  end

  def section
    return @section if @section
    @section, @strand, @number = Question.fast_split(self.name)
    @section
  end

  def strand
    return @strand if @strand
    @section, @strand, @number = Question.fast_split(self.name)
    @strand
  end

  def number
    return @number if @number
    @section, @strand, @number = Question.fast_split(self.name)
    @number
  end

  #44 seconds for 1M iterations
  private
  def self.fast_split(string)
    splits = string.split("_")
    number_to_return = splits.last
    section_to_return = @@Hashes['questions'].keys.select{|key| key.include?(splits.first)}.first
    return [nil, nil, nil] if section_to_return == nil
    strand_to_return = (splits - section_to_return.split("_") - [number_to_return]).join("_")
    return [section_to_return, strand_to_return, number_to_return]
  end

end
