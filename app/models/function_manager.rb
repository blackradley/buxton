#
# $URL
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class FunctionManager < User
  # The user controls a function.
  has_one :function, :dependent => :destroy
end