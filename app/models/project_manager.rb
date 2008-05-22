#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class ProjectManager < User
  belongs_to :project
  delegate :organisation, :organisation=, :to => :project
  delegate :activities, :to => :project

  validates_presence_of :email, 
    :message => 'Please provide an email'
  validates_format_of :email,
    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :message => 'E-mail must be valid'    
  
  def level
    self.term('project')
  end
end