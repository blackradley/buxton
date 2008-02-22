#
# $URL
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class OrganisationManager < User
  # The user controls an organisation.
  belongs_to :organisation 
end
