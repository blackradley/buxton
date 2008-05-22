#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class GroupingsController < ApplicationController
  # Groupings are nested resources underneath Organisations,
  # so we'll always have an Organisation to load first.
  before_filter :load_organisation
  
private
  # before_filter
  def load_organisation
    @organisation = Organisation.find(params[:organisation_id])
  end
end