#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class LogsController < ApplicationController
  
  before_filter :verify_index_access

  def index
    @logs = Log.find(:all, :order => 'created_at DESC')
  end
  
  def clear
    Log.destroy_all
    redirect_to :back
  end
  

protected

  # Secure the relevant methods in the controller.
  def secure?
    true
  end
  
  def get_related_model
    Log
  end
  
end