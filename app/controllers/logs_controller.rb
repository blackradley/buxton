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
  before_filter :verify_index_access

  def index
    @logs = Log.find(:all, :order => 'created_at DESC')
  end
  
  def clear
    Log.destroy_all
    redirect_to :back
  end
  
  def download
    outfile = File.open('log/impact_equality_logs.csv', "wb") 
    CSV::Writer.generate(outfile) do |csv|
      Log.all.map{|log| [log.message.gsub(/<.*?>/, ''), log.created_at]}.each do |log|
        csv << log
      end
    end
    outfile.close
    send_file 'log/impact_equality_logs.csv'
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