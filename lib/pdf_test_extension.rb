# Required by evensimplertable for header checking when at bottom of page

# Extend pdf to take a test pdf for test writing
module PDF
  class Writer
    attr_accessor :test_pdf

    alias_method :old_init, :initialize
        
    def initialize(args = {})
      unless args[:test]
        @test_pdf = PDF::Writer.new(args.merge(:test => true))
      end
      old_init(args.delete_if{|key, value| key == :test})      
    end
  
  end
  
end
