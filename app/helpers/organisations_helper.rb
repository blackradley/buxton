#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
module OrganisationsHelper
  
  def organisation_manager_login_url(organisation)
    "#{request.protocol}#{organisation.style}.#{request.domain(TLD_LENGTH)}#{request.port_string}/#{organisation.organisation_manager.passkey}"
  end

end