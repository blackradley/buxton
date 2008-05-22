#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class Terminology < ActiveRecord::Base
  has_many :organisation_terminologies, :dependent => :destroy
end
