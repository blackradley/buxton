require 'rubygems'
require 'pdf/writer'

module PDF  
  class Writer 
    alias_method :new_page, :new_page_without_background  
  end
end  