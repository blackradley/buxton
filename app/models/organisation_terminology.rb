class OrganisationTerminology < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :terminology
end
