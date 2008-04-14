class Comment < ActiveRecord::Base
  belongs_to :question
  
  def html_id
    "comment_#{self.id}"
  end
end
