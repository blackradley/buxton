# 
# $URL: http://svn3.cvsdude.com/BlackRadley/buxton/trunk/app/models/issue.rb $ 
# 
# $Rev: 370 $
# 
# $Author: 27Stars-Joe $
# 
# $Date: 2007-10-28 12:13:39 +0100 (Tue, 18 Oct 2007) $
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 

class Issue < ActiveRecord::Base
	belongs_to :function
	
end
