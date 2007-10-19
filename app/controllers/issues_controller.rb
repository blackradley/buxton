class IssuesController < ApplicationController
  
  def create
    @issue = Issue.new(params[:issue])
    @issue.save

    respond_to do |format|
      format.js
    end
  end
  
  def update
    @params[:issue].each do |index, data|
      issue = Issue.find(index)
      issue.update_attributes(data)
    end  
    redirect_to :back
  end
  
  def destroy
    @issue = Issue.find(@params[:id])
    @issue.destroy

    respond_to do |format|
      format.js
    end
  end
    
end