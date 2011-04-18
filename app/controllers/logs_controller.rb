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
  before_filter :requires_admin

  def index
    @selected = "activity_logging"
    @logs = Log.find(:all, :order => 'created_at DESC')
  end
  
  def clear
    Log.destroy_all
    redirect_to :back
  end
  
  def download
    outfile = File.open('log/impact_equality_logs.csv', "wb") 
    header_row = ["User",	"Organisation",	"Level", "Action", "Date", "Time"]	
    CSV::Writer.generate(outfile) do |csv|
      csv << header_row
      Log.csv.each do |log|
        csv << log
      end
    end
    outfile.close
    send_file 'log/impact_equality_logs.csv'
  end

end