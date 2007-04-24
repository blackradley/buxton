#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
class FunctionImpactGroup < ActiveRecord::Base
  belongs_to :function
  belongs_to :impact_group
end