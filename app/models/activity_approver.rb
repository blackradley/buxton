#
# $URL: http://svn3.cvsdude.com/BlackRadley/buxton/trunk/app/models/activity_manager.rb $
# $Rev: 992 $
# $Author: 27stars-karl $
# $Date: 2008-02-29 15:02:15 +0000 (Fri, 29 Feb 2008) $
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class ActivityApprover < User
  # The user approves an activity.
  belongs_to :activity
end
