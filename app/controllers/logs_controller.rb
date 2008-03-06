#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
class LogsController < ApplicationController

  def index
    @logs = Log.find(:all, :order => 'created_at DESC')
  end

protected

  # Secure the relevant methods in the controller.
  def secure?
    true
  end
  
end