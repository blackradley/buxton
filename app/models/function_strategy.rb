#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
# 
class FunctionStrategy < ActiveRecord::Base
  belongs_to :function
  belongs_to :strategy
end