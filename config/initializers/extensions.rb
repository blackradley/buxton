class String
  
  ALPHANUMERICS = [('0'..'9'),('A'..'Z'),('a'..'z')].map {|range| range.to_a}.flatten
  alias :orig_titlecase :titlecase
  def titlecase
    words = self.split(' ')
    result = []
    words.each do |word|
      if word == word.upcase
        result << word
      elsif word.downcase == 'or'
        result << 'or'
      else
        result << word.orig_titlecase
      end
    end
    result.join(' ')
  end
  
  def self.random_alphanumeric(length=8)
    (0..7).map { ALPHANUMERICS[Kernel.rand(ALPHANUMERICS.size)] }.join
  end
end