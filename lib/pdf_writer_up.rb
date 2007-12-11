require 'rubygems'
require 'pdf/writer'

module PDF  
  class Writer
    attr_accessor :unapproved_status
    
    alias_method :new_page_without_background, :new_page  
   
    def new_page(insert = false, page = nil, pos = :after)  
      new_page_without_background(insert, page, pos)
      stroke_color! Color::RGB.const_get('Gainsboro')
      fill_color! Color::RGB.const_get('Gainsboro')
      add_text(margin_x_middle-150, margin_y_middle-150, @unapproved_status.to_s , 72, 45)
      fill_color! Color::RGB.const_get('Black')
      stroke_color! Color::RGB.const_get('Black')
      current_page
    end
  end
end  