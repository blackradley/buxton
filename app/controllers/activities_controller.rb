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
  before_filter :set_activity, :only => [:edit, :questions, :update, :toggle_strand, :submit, :show, :approve, :reject, :submit_approval, :submit_rejection, :summary]
  before_filter :ensure_cop, :only => [:summary, :generate_schedule, :actions, :directorate_governance_eas]
  before_filter :ensure_completer, :only => [:my_einas]
  before_filter :ensure_activity_completer, :only => [:questions, :submit, :toggle_strand]
  before_filter :ensure_approver, :only => [:approving]
  before_filter :ensure_activity_approver, :only => [:approve, :reject, :submit_approval, :submit_rejection]
  before_filter :ensure_pdf_view, :only => [:show]

  autocomplete :user, :email, :scope => :live
  
  def index
    redirect_to root_path
  end
  
  def directorate_einas
    @breadcrumb = [["Directorate EAs"]]
    
    @directorates = current_user.count_directorates
    @live_directorates = current_user.count_live_directorates
    @service_areas = ServiceArea.where(:directorate_id => Directorate.where(:creator_id=>current_user.id).map(&:id))
    @activities = Activity.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.where(:creator_id=>current_user.id).map(&:id)})
    
    @selected = "directorate_einas"
  end
  
  def my_einas
    @breadcrumb = [["My EAs"]]
    @activities = Activity.where(:completer_id => current_user.id, :ready => true)
    @selected = "my_einas"
  end
  
  def clone
    original_activity = Activity.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.where(:creator_id=>current_user.id).map(&:id)}).find(params[:id])
    if original_activity
      @activity = Activity.new(original_activity.attributes)
      @clone_of = original_activity
      @activity.ready = false
      @activity.approved = false
      @activity.submitted = false
      @activity.start_date = nil
      @activity.end_date = nil
      @activity.review_on = nil
      render :new
    else
      redirect_to :directorate_einas
    end
  end
  
  def approving
    @breadcrumb = [["Awaiting Approval"]]
    @activities = Activity.where(:approver_id => current_user.id, :ready => true).reject{|a| a.progress == "NS"}
    @selected = "awaiting_approval"
  end
  
  def directorate_governance_eas
    @breadcrumb = [["EA Governance"]]
    @activities =  Activity.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.where(:cop_id=>current_user.id).map(&:id)}, :ready => true)
    @selected = "directorate_governance_eas"
  end
  
  def new
    # @directorates = Directorate.where(:creator_id=>current_user.id)
    @breadcrumb = [["Directorate EAs", directorate_einas_activities_path], ["New EA"]]
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
    @activity.service_area = services.first
    @activity.approver = services.first.approver if services.first
  end

  def create
    if params[:clone_of]
      @activity = current_user.activities.select{|a| a.id.to_s == params[:clone_of]}.first.clone
    else
      @activity = Activity.new()
    end
    Strategy.live.each do |s|
      @activity.activity_strategies.build(:strategy => s) unless @activity.activity_strategies.map(&:strategy).include?(s)
    end
    @activity.ref_no = "EA#{sprintf("%06d", Activity.last(:order => :id).id + 1)}"
    # @directorate = Directorate.find_by_creator_id(current_user.id)
    @breadcrumb = [["Directorate EAs", directorate_einas_activities_path], ["New EA"]]
    @selected = "directorate_einas"
    if @activity.update_attributes(params[:activity])
      flash[:notice] = "#{@activity.name} was created."
      Mailer.activity_created(@activity).deliver if @activity.ready?
      redirect_to directorate_einas_activities_path
    else
      if !@activity.errors[:completer].blank?
        @activity.errors.add(:completer_email, "An EA must have someone assigned to undergo the assessment")
      end
      if !@activity.errors[:approver].blank?
        @activity.errors.add(:approver_email, "An EA must have someone assigned to approve the assessment")
      end
      @service_areas = ServiceArea.where(:directorate_id => Directorate.where(:creator_id=>current_user.id).map(&:id))
      render 'new'
    end
  end
  
  
  def edit
    @breadcrumb = [["Directorate EAs", directorate_einas_activities_path], ["New EA"]]
    @directorate = Directorate.find_by_creator_id(current_user.id)
    @service_areas = ServiceArea.where(:directorate_id => Directorate.where(:creator_id=>current_user.id).map(&:id))
    @selected = "directorate_einas"
    @activity = Activity.find(params[:id])
  end

  # Update the activity details accordingly.
  # Available to: Activity Manager
  def update
    @breadcrumb = [["Directorate EAs", directorate_einas_activities_path], ["New EA"]]
    @directorate = Directorate.find_by_creator_id(current_user.id)
    @selected = "directorate_einas"
    @activity = Activity.find(params[:id])
    Strategy.live.each do |s|
      @activity.activity_strategies.find_or_create_by_strategy_id(s.id)
    end
    @activity.activity_strategies.each do |s|
      s.destroy if s.strategy.retired?
    end
    if @activity.update_attributes(params[:activity])
      flash[:notice] = "#{@activity.name} was updated."
      Mailer.activity_created(@activity).deliver if @activity.ready?
      redirect_to directorate_einas_activities_path
    else
      if !@activity.errors[:completer].blank?
        @activity.errors.add(:completer_email, "An EA must have someone assigned to undergo the assessment")
      end
      if !@activity.errors[:approver].blank?
        @activity.errors.add(:approver_email, "An EA must have someone assigned to approve the assessment")
      end
      @service_areas = ServiceArea.where(:directorate_id => Directorate.where(:creator_id=>current_user.id).map(&:id))
      render "edit"
    end
  end
  
  def submit
    #TODO: setup approver
    if @activity.completed
      @activity.submitted = true
      @activity.save!
      flash[:notice] = 'Your EA has been successfully submitted for approval.'
    else
      flash[:error] = "You need to finish your EA before you can submit it."
    end
    redirect_to questions_activity_path(@activity)
  end

  # Opening page where they must choose between Activity/Policy and Existing/Proposed
  # Available to: Activity Manager
  def questions
    @selected = "my_einas"
    @breadcrumb = [["My EAs", my_einas_activities_path], ["#{@activity.name}"]]
    completed_status_array = @activity.strands(true).map{|strand| [strand.to_sym, @activity.completed(nil, strand)]}
    completed_status_hash = Hash[*completed_status_array.flatten]
    tag_test = completed_status_hash.select{|k,v| !v}.map(&:first).map do |strand_status|
      "($('#{strand_status.to_s}_checkbox').checked)"
    end
  end


  def summary
    render :partial => "summary"
  end
  
  def generate_schedule
    activities = []
    if current_user.corporate_cop?
      activities = Activity.where(:id => params[:activities])
    elsif current_user.directorate_cop?
      activities = Activity.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.where(:cop_id=>current_user.id).map(&:id)}, :id => params[:activities], :ready => true)
    end
    send_data SchedulePDFGenerator.new(activities).pdf.render, :disposition => 'inline',
      :filename => "schedule.pdf",
      :type => "application/pdf"
  end
  
  def actions
    service_area_list = current_user.corporate_cop? ? ServiceArea.all : Directorate.where(:cop_id=>current_user.id).map(&:service_areas).flatten
    @service_areas = service_area_list.map do |sa|
      [sa, Issue.includes(:activity => {:service_area => :directorate}).where(:directorates => {:cop_id => current_user.id}).count]
    end
  end
  
  def show
    type = params[:type]
    log_event('PDF', %Q[The PDF for the <strong>#{@activity.name}</strong> EA, within directorate <strong>#{@activity.directorate.name}</strong>, was viewed by #{current_user.email}])
    send_data ActivityPDFGenerator.new(@activity, type).pdf.render, :disposition => 'inline',
      :filename => "#{@activity.name}.pdf",
      :type => "application/pdf"
  end

  def toggle_strand
    return false if @activity.submitted
    unless @activity.strand_required?(params[:strand])
      @activity.toggle("#{params[:strand]}_relevant")
      @activity.save!
    end
    render :nothing => true
  end
  
  
  def approve
    render :layout =>false
  end
  
  def reject
    render :layout =>false
  end
  
  def submit_approval
    @activity.update_attributes(:approved => true)
    Mailer.activity_approved(@activity, params[:email_contents]).deliver
    redirect_to approving_activities_path
  end
  
  def submit_rejection
    @activity.update_attributes(:submitted => false)
    Mailer.activity_rejected(@activity, params[:email_contents]).deliver
    redirect_to approving_activities_path
  end

protected
  
  def ensure_pdf_view
     redirect_to access_denied_path unless current_user.creator? || current_user.approver? || current_user.completer? || current_user.corporate_cop? || current_user.directorate_cop?
  end
  
  
  def set_activity
    @activity = current_user.activities.select{|a| a.id == params[:id].to_i}.first
    return false unless @activity
  end
  
  def ensure_activity_completer
     redirect_to access_denied_path unless @activity.completer == current_user
  end
  
  def ensure_activity_approver
     redirect_to access_denied_path unless @activity.approver == current_user
  end
end
