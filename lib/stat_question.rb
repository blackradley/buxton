#This class simulates a question, and contains a lookup, a name, and the current result of the lookup.

class StatQuestion
  attr_reader :name, :scores, :max
  #This sets all the values, and sets the maximum values.
  def initialize(value, name, hashes)
    @name = name
    @max = 0
    @scores = 0
    hash_weights = hashes['weights']
    if (value[0] == 'select') then
      @weights = hash_weights[value[1]]
      @weights.each{|weight| @max = weight.to_i unless @max >= weight.to_i}
    else
      @max = 0
    end
  end
  #This returns the score of the question to a particular response. Text questions are automatically scored 0.
  #Hence, this is why it is possible to have a section with a score of 0, as (for example, as action planning is) it
  #could be full of text questions with no lookups with values.
  def score(response)
    @max = 0 if response.nil?
    @scores = 0
    return 0 unless @weights
    @scores = @weights[response.to_i].to_i
    return @scores
  end
end