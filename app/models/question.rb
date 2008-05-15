class Question < ActiveRecord::Base
  belongs_to :activity
  has_one :comment, :dependent => :destroy
  has_one :note, :dependent => :destroy
  validates_uniqueness_of :name, :scope => :activity_id
  attr_reader :section, :strand, :number
  
  def weights
    [*@@Hashes['weights'][@@weight_ids[self.name.to_sym]]].map(&:to_i)
  end

  def weight
    weights[self.response.to_i]
  end

  def invisible?
    (@@invisible_questions.include?(self.name) && self.activity.proposed?)
  end

  def response
    self.activity.send(self.name.to_sym)
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
  
  def parent
    self.activity.questions.find_by_name(Question.parents(self.name.to_s)[0].to_s)
  end
  
  def parent_value
    Question.parents(self.name.to_s)[1]
  end
  
  def children
    Question.dependencies(self.name.to_s).map{|child| self.activity.questions.find_by_name(child[0].to_s)}
  end

  def check_response #Check response verifies whether a response to a question is correct or not.
    checker = !(response.to_i == 0)
    checker = ((response.to_s.length > 0)&&response.to_s != "0") unless checker
    return checker
  end
  
  def check_needed
    parent_okay = self.parent.nil? ? true : (self.parent.response.to_s == parent_value.to_s)
    return false if invisible?
    parent_okay
  end
  
  def update_status
    self.completed = check_response
    self.needed = check_needed
    save!
    children.each do |child|
      child.update_status
    end
  end
  
  #global methods pertaining to questions
  def self.dependencies(question = nil)
    return @@dependencies.clone unless question
    return @@dependencies[question].clone if @@dependencies[question]
    []
  end
  def self.parents(question = nil)
    return @@parents.clone unless question
    return @@parents[question].clone if @@parents[question]
    []
  end

  #44 seconds for 1M iterations
  private
  def self.fast_split(string)
    @@Hashes = YAML.load_file("#{RAILS_ROOT}/config/questions.yml") unless @@Hashes
    string = string.to_s
    splits = string.split("_")
    number_to_return = splits.last
    section_to_return = @@Hashes['questions'].keys.select{|key| key.include?(splits.first)}.first
    return [nil, nil, nil] if section_to_return == nil
    strand_to_return = (splits - section_to_return.split("_") - [number_to_return]).join("_")
    return [section_to_return, strand_to_return, number_to_return]
  end

end
