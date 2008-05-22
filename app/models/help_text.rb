#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class HelpText < ActiveRecord::Base
  def self.hashes
    @@Hashes
  end
end
