#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class LogsController < ApplicationController
  require 'csv'
  before_filter :authenticate_user!
  before_filter :ensure_corporate_cop

  def index
    @selected = "activity_logging"
    @logs = Log.find(:all, :order => 'created_at DESC')
  end
  
end