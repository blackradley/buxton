# Required by evensimplertable for header checking when at bottom of page

# Extend pdf to take a test pdf for test writing
module PDF
  class Writer
    attr_accessor :test
    
    self.class_eval {alias_method :old_init, :initialize}
    
    def initialize(test = false)
      old_init
      @test = PDF::Writer.new(true) unless test
    end
  end
end
