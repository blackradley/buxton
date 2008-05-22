#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class Note < ActiveRecord::Base
  belongs_to :question
  belongs_to :activity_strategy
end
