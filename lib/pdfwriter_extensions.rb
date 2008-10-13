
CONVERTER = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'utf-8')

module PDF
  class Writer
    alias_method :old_text, :text
    alias_method :old_add_text, :add_text
    alias_method :old_add_text_wrap, :add_text_wrap

    def text(text, options = {})
      old_text(CONVERTER.iconv(text), options)
    end
    
    def add_text(x, y, text, size = nil, angle = 0, word_space_adjust = 0)
      old_add_text(x, y, CONVERTER.iconv(text), size, angle, word_space_adjust)
    end
    
    def add_text_wrap(x, y, width, text, size = nil, justification = :left, angle = 0, test = false)
      old_add_text_wrap(x, y, width, CONVERTER.iconv(text), size, justification, angle, test)
    end
  end  
end