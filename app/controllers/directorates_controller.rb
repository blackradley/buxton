class DirectoratesController < ApplicationController

  # Available to: Administrator
  def new
    @directorate = Directorate.new
  end
 
  # Available to: Administrator
  def create   
    @directorate = Organisation.find(params[:org_id]).directorates.build(params[:directorate])
    @directorate.save

    respond_to do |format|
      format.js
    end
  end
  
  # Available to: Administrator
  def destroy
    @directorate = Directorate.find(params[:id])
    @directorate.destroy

    respond_to do |format|
      format.js
    end
  end
  
end
