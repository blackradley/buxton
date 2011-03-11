#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class Administrator < User
  # The user has no activity or organisation.
  # 
  
  
  def creator?
    false
  end
  
  def activity_manager?
    false
  end
  
  def activity_approver?
    false
  end
  
end