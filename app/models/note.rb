class Note < ActiveRecord::Base
  belongs_to :question
  belongs_to :activity_strategy
end
