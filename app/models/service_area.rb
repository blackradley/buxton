#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class ServiceArea < ActiveRecord::Base
  attr_protected
  belongs_to :directorate
  belongs_to :approver, :class_name => "User"
  validates_presence_of :name, :directorate
  validates_presence_of :approver_email, :message => "must be a valid user"
  validates_associated :directorate, :approver
  has_many :activities

  attr_accessor :should_destroy

  scope :active,  lambda{
      joins(:directorate).where(:directorates => {:retired => false}, :retired => false).readonly(false)
    }
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
    self.approver = User.live.find_by(email: email)
  end

end
