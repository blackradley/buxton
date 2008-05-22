# 
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
class Log < ActiveRecord::Base
  ICON = ''
  
  def icon
    self.class::ICON
  end  
end