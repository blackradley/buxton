
# CONVERTER = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'utf-8')

module PDF
  class Writer
    alias_method :old_text, :text
    alias_method :old_add_text, :add_text
    alias_method :old_add_text_wrap, :add_text_wrap

    def convert(text)
      text.scrub.gsub(/[“”]/, "\"").gsub(/–/, "-")
    rescue
      text.to_s.gsub(/[“”]/, "\"").gsub(/–/, "-")
    end

    def text(text, options = {})
      old_text(convert(text), options)
    end

    def add_text(x, y, text, size = nil, angle = 0, word_space_adjust = 0)
      old_add_text(x, y, convert(text), size, angle, word_space_adjust)
    end

    def add_text_wrap(x, y, width, text, size = nil, justification = :left, angle = 0, test = false)
      old_add_text_wrap(x, y, width, convert(text), size, justification, angle, test)
    end
  end
end
