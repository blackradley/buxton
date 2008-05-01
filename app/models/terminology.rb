class Terminology < ActiveRecord::Base
  has_many :organisation_terminologies, :dependent => :destroy
end
