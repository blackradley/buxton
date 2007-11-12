#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
# Issues are currently set in Confidence Consultation and filled in in Action Planning
class IssuesController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # Ensure create/destroy are only accessible via POST && XMLHttpRequest
  verify  :method => :post,
          :xhr => true,
          :only => [ :create, :destroy ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }
  verify  :method => :post,
          :only => [ :update ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }
  
  # Create a new issue and reply with the appropriate RJS
  def create
    @issue = Issue.new(params[:issue])
    @issue.save

    respond_to do |format|
      format.js
    end
  end
  
  # Update issue(s)
  def update
    # Loop through all the issues, given to us after auto-indexing the form data
    # (see: http://www.railsforum.com/viewtopic.php?pid=42791)
    params[:issue].each do |id, data|
      issue = Issue.find(id)
      issue.update_attributes(data)
    end
    flash[:notice] =  "Action Planning was successfully updated."
    redirect_to :back
  end
  
  # Destroy an issue and reply with the appropriate RJS
  def destroy
    @issue = @current_user.function.issues.find(params[:id])
    @issue.destroy

    respond_to do |format|
      format.js
    end
  rescue ActiveRecord::RecordNotFound => e
    render :inline => 'Invalid ID.'
  end

protected
  # Secure the relevant methods in the controller.
  def secure?
    true
  end
end