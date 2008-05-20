#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class OrganisationManager < User
  # The user controls an organisation.
  belongs_to :organisation
  delegate :activities, :to => :organisation

  validates_presence_of :email, 
    :message => 'Please provide an email'
  validates_format_of :email,
    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :message => 'E-mail must be valid'
  
  attr_accessor :should_destroy

  def should_destroy?
    should_destroy.to_i == 1
  end
end
