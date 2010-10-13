#
# $URL: http://svn3.cvsdude.com/BlackRadley/buxton/trunk/app/models/activity_manager.rb $
# $Rev: 992 $
# $Author: 27stars-karl $
# $Date: 2008-02-29 15:02:15 +0000 (Fri, 29 Feb 2008) $
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class ActivityApprover < User
  # The user approves an activity.
  belongs_to :activity
  delegate :organisation, :organisation=, :to => :activity
  delegate :directorate, :directorate=, :to => :activity
  validates_presence_of :email,
    :message => 'Please provide an email'
  # validates_format_of :email,
  #   :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
  #   :message => 'E-mail must be valid'    
    
  def before_create
    self.passkey = ActivityCreator.generate_passkey(self) unless self.passkey
  end    
end
