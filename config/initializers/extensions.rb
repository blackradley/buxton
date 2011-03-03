class String
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
end