#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class ActivitiesController < ApplicationController

  # verify  :method => :post,
  #         :only => [ :destroy, :create, :update, :update_activity_type, :update_contact, :update_ces ],
  #         :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  rescue_from ActiveRecord::RecordInvalid, :with => :show_errors

  # Make render_to_string available to the #show action
  helper_method :render_to_string
  before_filter :authenticate_user!
  before_filter :ensure_creator, :only => [:edit, :new, :create, :update, :directorate_einas]
  before_filter :ensure_completer, :only => [:questions, :submit, :toggle_strand, :my_einas]
  before_filter :ensure_approver, :only => [:assisting]
  before_filter :ensure_pdf_view, :only => [:show]
  before_filter :set_activity, :only => [:edit, :questions, :update, :toggle_strand, :submit, :show]
  autocomplete :user, :email, :scope => :live
  
  def index
    redirect_to root_path
  end
  
  def directorate_einas
    @breadcrumb = [["Directorate EINAs"]]
    
    @directorates = current_user.count_directorates
    @live_directorates = current_user.count_live_directorates
    @activities = Activity.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.where(:creator_id=>current_user.id).map(&:id)})
    
    @selected = "directorate_einas"
  end
  
  def my_einas
    @breadcrumb = [["My EINAs"]]
    @activities = Activity.where(:completer_id => current_user.id)
    @selected = "my_einas"
  end
  
  def approving
    @breadcrumb = [["Awaiting Approval"]]
    @activities = Activity.where(:approver_id => current_user.id)
    @selected = "awaiting_approval"
  end
  
  def new
    # @directorates = Directorate.where(:creator_id=>current_user.id)
    @breadcrumb = [["Directorate EINAs", directorate_einas_activities_path], ["New EINA"]]
    services = ServiceArea.where(:directorate_id => Directorate.where(:creator_id=>current_user.id, :retired =>false).map(&:id))
    if current_user.count_directorates > 1
      @service_areas = Hash.new
      services.each do |s|
        @service_areas["#{s.name} - #{s.directorate.name}"] = s.id
      end
    else
      @service_areas = services
    end
    @selected = "directorate_einas"
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(params[:activity])
    # @directorate = Directorate.find_by_creator_id(current_user.id)
    @breadcrumb = [["Directorate EINAs", directorate_einas_activities_path], ["New EINA"]]
    @selected = "directorate_einas"
    if @activity.save
      flash[:notice] = "#{@activity.name} was created."
      Mailer.activity_created(@activity).deliver
      redirect_to directorate_einas_activities_path
    else
      @service_areas = ServiceArea.where(:directorate_id => Directorate.where(:creator_id=>current_user.id).map(&:id))
      render 'new'
    end
  end
  
  
  def edit
    @breadcrumb = [["Directorate EINAs", directorate_einas_activities_path], ["New EINA"]]
    @directorate = Directorate.find_by_creator_id(current_user.id)
    @service_areas = ServiceArea.where(:directorate_id => Directorate.where(:creator_id=>current_user.id).map(&:id))
    @selected = "directorate_einas"
    @activity = Activity.find(params[:id])
  end

  # Update the activity details accordingly.
  # Available to: Activity Manager
  def update
    @breadcrumb = [["Directorate EINAs", directorate_einas_activities_path], ["New EINA"]]
    @directorate = Directorate.find_by_creator_id(current_user.id)
    @selected = "directorate_einas"
    @activity = Activity.find(params[:id])
    
    if @activity.update_attributes!(params[:activity])
      flash[:notice] = "#{@activity.name} was updated."
      redirect_to directorate_einas_activities_path
    else
      render "edit"
    end
  end
  
  def submit
    #TODO: setup approver
    @activity.approved = "submitted"
    @activity.save
    flash[:notice] = 'Your activity has been successfully submitted for approval.'
    redirect_to questions_activity_path(@activity)
  end

  # Opening page where they must choose between Activity/Policy and Existing/Proposed
  # Available to: Activity Manager
  def questions
    @selected = "my_einas"
    @breadcrumb = [["My EINAs", my_einas_activities_path], ["#{@activity.name}"]]
    completed_status_array = @activity.strands(true).map{|strand| [strand.to_sym, @activity.completed(nil, strand)]}
    completed_status_hash = Hash[*completed_status_array.flatten]
    tag_test = completed_status_hash.select{|k,v| !v}.map(&:first).map do |strand_status|
      "($('#{strand_status.to_s}_checkbox').checked)"
    end
  end

  
  def show
    type = params[:type]
    # log_event('PDF', %Q[The PDF for the <strong>#{@activity.name}</strong> EINA, within directorate <strong>#{@activity.directorate.name}</strong>, was viewed by #{current_user.email}])
    send_data ActivityPDFGenerator.new(@activity, type).pdf.render, :disposition => 'inline',
      :filename => "#{@activity.name}.pdf",
      :type => "application/pdf"
  end

  def toggle_strand
    unless @activity.strand_required?(params[:strand])
      @activity.toggle("#{params[:strand]}_relevant")
      @activity.save!
    end
    render :nothing => true
  end
  
  
protected
  
  def ensure_pdf_view
    current_user.creator? || current_user.approver? || current_user.completer?
  end
  
  
  def set_activity
    @activity = current_user.activities.select{|a| a.id == params[:id].to_i}.first
  end
end
