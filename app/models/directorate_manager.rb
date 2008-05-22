#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class DirectorateManager < User
  # The user controls a directorate.
  belongs_to :directorate
  delegate :organisation, :organisation=, :to => :directorate
  delegate :activities, :to => :directorate
  
  validates_presence_of :email, 
    :message => 'Please provide an email'
  validates_format_of :email,
    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :message => 'E-mail must be valid'

  def level
    self.term('directorate')
  end
end