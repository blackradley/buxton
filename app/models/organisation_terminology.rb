#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class OrganisationTerminology < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :terminology
end
