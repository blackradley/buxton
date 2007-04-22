#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
class Organisation < ActiveRecord::Base
  belongs_to :user
  has_many :functions
  validates_presence_of :name
  
#
# Retun a float for the percentage of questions answered
#
  def percentage_completed
  # TODO: Calculate the percentage of questions answered
  # Some monkeying with SQL might come up with something suitable
    return rand(100)
  end
end
