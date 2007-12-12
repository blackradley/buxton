# 
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.  
# 
# The FunctionStrategy is used to store responses about how much the Function
# contributes to the Organisation strategies.  
# 
# Each Organisation has a set of strategies and each Function (well really the
# Activity manager) has to say how much they contribute to each of the strategies.
# So it is not really a many to many relationship.
# 
class ActivityStrategy < ActiveRecord::Base
  belongs_to :activity
  belongs_to :strategy
end