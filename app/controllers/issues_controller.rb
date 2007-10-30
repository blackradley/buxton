# Issues are currently set in Confidence Consultation and filled in in Action Planning
class IssuesController < ApplicationController
  
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
    @params[:issue].each do |id, data|
      issue = Issue.find(id)
      issue.update_attributes(data)
    end
    flash[:notice] =  "Action Planning was successfully updated."
    redirect_to :back
  end
  
  # Destroy an issue and reply with the appropriate RJS
  def destroy
    @issue = Issue.find(@params[:id])
    @issue.destroy

    respond_to do |format|
      format.js
    end
  end
    
end