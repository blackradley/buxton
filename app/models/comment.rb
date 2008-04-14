class Comment < ActiveRecord::Base
  belongs_to :question
  belongs_to :activity_strategy

  def html_id
    "comment_#{self.id}"
  end

end
