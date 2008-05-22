#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class ActivityCreator < User
  # The user creates an activity.
  belongs_to :organisation
  
  def before_create
    self.passkey = ActivityCreator.generate_passkey(self) unless self.passkey
  end
end
