#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class Terminology < ActiveRecord::Base
  attr_protected
  has_many :organisation_terminologies, :dependent => :destroy
end
