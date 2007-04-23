#  
# $URL: http://svn3.cvsdude.com/BlackRadley/buxton/trunk/app/models/impact_group.rb $
# $Rev: 89 $
# $Author: BlackRadleyJoe $
# $Date: 2007-04-22 21:56:17 +0100 (Sun, 22 Apr 2007) $
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
class FunctionImpactGroup < ActiveRecord::Base
  belongs_to :function
  belongs_to :impact_group
end