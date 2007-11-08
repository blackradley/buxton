#This class simulates a question, and contains a lookup, a name, and the current result of the lookup.

class StatQuestion
  attr_reader :name, :scores, :max
  #This sets all the values, and sets the maximum values.
  def initialize(value, name)
    @name = name
    @max = 0
    @scores = 0
    unless value == :text || value == :string then
  @lookup = LookUp.send(value)
  @lookup.each{|lookup| @max = lookup.attributes["weight"] unless (@max >= lookup.attributes["weight"])}
    else
  @max = 0
    end
  end
  #This returns the score of the question to a particular response. Text questions are automatically scored 0.
  #Hence, this is why it is possible to have a section with a score of 0, as (for example, as action planning is) it
  #could be full of text questions with no lookups with values.
  def score(response)
    @scores = 0
    return 0 unless @lookup
    @lookup.each{|lookup_option| @scores = lookup_option.attributes["weight"] if lookup_option.attributes["value"] == response}
    return @scores
  end
end