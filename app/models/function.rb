#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
# 
class Function < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user
  validates_associated :user
  belongs_to :organisation
  has_many :function_strategies
  validates_presence_of :name,
    :message => 'All functions must have a name'

end
