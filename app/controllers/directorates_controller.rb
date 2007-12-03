class DirectoratesController < ApplicationController
def new
    @directorate = Directorate.new
end

# def create
#     @directorate = Directorate.new(params[:directorate])
#     begin
#       Directorate.transaction do
#         @directorate.save!
#       end
#     rescue ActiveRecord::RecordNotSaved
#         flash[:notice] = "Directorate creation failed. Please try again, and if it continues to fail, contact an administrator."
#         render :action => :new, :controller => 'organisations'    
#     end
#  end
 
 def create
   
    @directorate = Organisation.find(params[:org_id]).directorates.build(params[:directorate])
    @directorate.save

    respond_to do |format|
      format.js
    end
  end
  
def destroy
    @directorate = Directorate.find(params[:id])
    @directorate.destroy

    respond_to do |format|
      format.js
    end
end
end
