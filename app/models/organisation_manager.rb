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
  attr_accessor :should_destroy


  def should_destroy?
    should_destroy.to_i == 1
  end

  def after_create
    self.update_attributes(:passkey => OrganisationManager.generate_passkey(self))
  end
end
