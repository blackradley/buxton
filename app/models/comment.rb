#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class Comment < ActiveRecord::Base
  belongs_to :question
  belongs_to :activity_strategy

  def html_id
    "comment_#{self.id}"
  end

end
