require 'rubygems'
require 'pdf/writer'

module PDF  
  class Writer
    attr_accessor :directorate
    attr_accessor :current_page
    attr_accessor :unapproved_status
    attr_accessor :objects
    attr_accessor :pageset
    attr_accessor :current_contents
    attr_accessor :current_font
    alias_method :new_page_without_background, :new_page  
    
    @@proxy = nil
    
    def set_proxy(proxy)
      @@proxy = proxy
    end
    
    def get_proxy
      return @@proxy
    end
    
    def add_content(cc)
      if @@proxy then
        @@proxy << cc 
      end
      @current_contents << cc
    end
    
    def new_page(insert = false, page = nil, pos = :after)
      if @@proxy then
        @@proxy << :new_page
      end
      if directorate then
        new_page_without_background(insert, page, pos)
        left = absolute_left_margin
        right = absolute_right_margin
        add_image_from_file("#{RAILS_ROOT}/public/images/pdf_logo.png", (absolute_x_middle - 119), (absolute_y_middle + 17), 239)
        add_text_wrap(left, absolute_y_middle, right-left,  "<b>#{directorate.name}</b>", 24, :center)
        add_text_wrap(left, absolute_y_middle - 14, right-left,  "Impact Equality#{153.chr} Directorate Report", 12, :center)
        current_page
      else
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
end  