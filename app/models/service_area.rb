#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class ServiceArea < ActiveRecord::Base
  belongs_to :directorate
  belongs_to :approver, :class_name => "User"
  validates_presence_of :name, :approver, :directorate
  validates_associated :directorate, :approver
  
  attr_accessor :should_destroy
  
  include FixInvalidChars
  
  before_save :fix_name
  
  def fix_name
    self.name = fix_field(self.name)
  end
  
  
  def approver_email
    if self.approver
      self.approver.email
    else
      ""
    end
  end
  
  def approver_email=(email)
    self.approver_id = User.live.find_by_email(email)
  end

end
