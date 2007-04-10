#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
module UserHelper
#
# An object for creating an enum.  Usage:
#
# class Foo
#  enums %w(FOO BAR BAZ)
#  bitwise_enums %w(ONE TWO FOUR EIGHT)
# end
# 
# Then retrieve them like this:
# 
# Foo::FOO
# Foo::ONE
# 
  class Enum
  # Normal enum
    def self.enums(*args)    
      args.flatten.each_with_index do | const, i |
        class_eval %(#{const} = #{i})
      end
    end
  # Bitwise enum
    def self.bitwise_enums(*args)    
      args.flatten.each_with_index do | const, i |
        class_eval %(#{const} = #{2**i})
      end
    end
  end

end

