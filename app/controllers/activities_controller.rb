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

  # rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  # rescue_from ActiveRecord::RecordInvalid, :with => :show_errors

  # Make render_to_string available to the #show action
  helper_method :render_to_string
  before_filter :authenticate_user!
  before_filter :ensure_creator, :only => [:edit, :new, :create, :update, :directorate_eas]
  before_filter :set_activity, :only => [:edit, :task_group, :add_task_group_member, :remove_task_group_member, :create_task_group_member,
                                          :questions, :update, :toggle_strand, :submit, :show, :approve, :reject, :submit_approval, :submit_rejection,
                                          :task_group_comment_box, :make_task_group_comment, :summary, :comment, :submit_comment]
  before_filter :ensure_cop, :only => [:summary, :generate_schedule, :actions, :directorate_governance_eas]
  before_filter :ensure_completer, :only => [:my_eas, :task_group, :add_task_group_member, :remove_task_group_member, :create_task_group_member]
  before_filter :ensure_activity_completer, :only => [:questions, :submit, :toggle_strand]
  before_filter :ensure_approver, :only => [:approving]
  before_filter :ensure_task_group_member, :only => [:assisting]
  before_filter :ensure_quality_control, :only => [:quality_control]
  before_filter :ensure_activity_task_group_member, :only => [:task_group_comment_box, :make_task_group_comment]
  before_filter :ensure_activity_quality_control, :only => [:comment, :submit_comment]
  before_filter :ensure_activity_approver, :only => [:approve, :reject, :submit_approval, :submit_rejection]
  before_filter :ensure_pdf_view, :only => [:show]
  before_filter :ensure_activity_editable, :only => [:edit, :update]

  autocomplete :user, :email, :scope => :live
  
  def index
    redirect_to root_path
  end
  
  def directorate_eas
    @breadcrumb = [["Directorate EAs"]]
    @directorates = current_user.count_directorates
    @live_directorates = current_user.count_live_directorates
    @service_areas = ServiceArea.active.where(:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id))
    @activities = Activity.active.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id)})
    @selected = "directorate_eas"
  end
  
  def my_eas
    @breadcrumb = [["My EAs"]]
    @activities = Activity.active.where(:completer_id => current_user.id, :ready => true)
    @selected = "my_eas"
  end
  
  def clone
    original_activity = Activity.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id)}).find(params[:id])
    if original_activity
      @breadcrumb = [["Directorate EAs", directorate_eas_activities_path], ["Clone #{original_activity.name}"]]
      @selected = "directorate_eas"
      @service_areas = ServiceArea.active.where(:directorate_id => Directorate.where(:creator_id=>current_user.id, :retired =>false).map(&:id))
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
      redirect_to :directorate_eas
    end
  end
  
  def quality_control
    @breadcrumb = [["Quality Control"]]
    @activities = Activity.active.where(:qc_officer_id => current_user.id, :ready => true)
    @selected = "quality_control"
  end
  
  def assisting
    @breadcrumb = [["Assisting"]]
    @activities = Activity.active.includes(:task_group_memberships).where(:task_group_memberships => {:user_id => current_user.id})
    @selected = "assisting"
  end
  
  def approving
    @breadcrumb = [["Awaiting Approval"]]
    @activities = Activity.active.where(:approver_id => current_user.id, :ready => true)
    @selected = "awaiting_approval"
  end
  
  def directorate_governance_eas
    @breadcrumb = [["EA Governance"]]
    @activities =  Activity.active.ready.includes(:service_area)
    unless current_user.corporate_cop?
      @activities = []
      if current_user.creator?
        @activities += Activity.active.ready.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id)}, :ready => true)
      end
      @activities += Activity.active.ready.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:cop_id=>current_user.id).map(&:id)}, :ready => true)
    end
    @selected = "ea_governance"
  end
  
  def new
    # @directorates = Directorate.where(:creator_id=>current_user.id)
    @breadcrumb = [["Directorate EAs", directorate_eas_activities_path], ["New EA"]]
    services = ServiceArea.active.where(:directorate_id => Directorate.active.where(:creator_id=>current_user.id, :retired =>false).map(&:id))
    @selected = "directorate_eas"
    @activity = Activity.new
    @activity.service_area = services.first
    @activity.approver = services.first.approver if services.first
  end

  def create
    invalid = params[:activity].select{|k,v| k.match(/_email/) && !v.blank? && !User.live.exists?(:email => v)}#.each do |k,v|
    unless invalid.empty?
      @activity = Activity.new(params[:activity])
      invalid.each do |k,v|
        @activity.errors.add(k, "is not a valid user")
        @activity.instance_variable_set("@#{k}", v)
      end
      @service_areas = ServiceArea.active.where(:directorate_id => Directorate.where(:creator_id=>current_user.id).map(&:id))
      render 'new' and return
    end
    if params[:clone_of]
      @activity = current_user.activities.select{|a| a.id.to_s == params[:clone_of]}.first
      unless @activity
        flash[:notice] = "The Service Area for this EA has been retired and therefore this EA cannot be cloned."
        redirect_to directorate_eas_activities_path and return
      else
        @activity = @activity.clone
      end
    else
      @activity = Activity.new()
    end
    Strategy.live.each do |s|
      @activity.activity_strategies.build(:strategy => s) unless @activity.activity_strategies.map(&:strategy).include?(s)
    end
    # @directorate = Directorate.find_by_creator_id(current_user.id)
    @breadcrumb = [["Directorate EAs", directorate_eas_activities_path], ["New EA"]]
    @selected = "directorate_eas"
    if @activity.update_attributes(params[:activity])
      flash[:notice] = "#{@activity.name} was created."
      Mailer.activity_created(@activity).deliver if @activity.ready?
      redirect_to directorate_eas_activities_path
    else
      if !@activity.errors[:completer].blank?
        @activity.errors.add(:completer_email, "An EA must have someone assigned to undergo the assessment")
      end
      if !@activity.errors[:approver].blank?
        @activity.errors.add(:approver_email, "An EA must have someone assigned to approve the assessment")
      end
      if !@activity.errors[:qc_officer].blank?
        @activity.errors.add(:qc_officer_email, "An EA must have someone assigned as a Quality Control Officer for the assessment")
      end
      @service_areas = ServiceArea.active.where(:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id))
      render 'new'
    end
  end
  
  
  def edit
    @breadcrumb = [["Directorate EAs", directorate_eas_activities_path], ["Edit EA"]]
    @directorate = Directorate.find_by_creator_id(current_user.id)
    @service_areas = ServiceArea.active.where(:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id))
    @selected = "directorate_eas"
    @activity = Activity.find(params[:id])
  end

  # Update the activity details accordingly.
  # Available to: Activity Manager
  def update
    @breadcrumb = [["Directorate EAs", directorate_eas_activities_path], ["New EA"]]
    @directorate = Directorate.find_by_creator_id(current_user.id)
    @selected = "directorate_eas"
    @activity = Activity.find(params[:id])
    
    invalid = params[:activity].select{|k,v| k.match(/_email/) && !v.blank? && !User.live.exists?(:email => v)}#.each do |k,v|
    unless invalid.empty?
      invalid.each do |k,v|
        @activity.errors.add(k, "is not a valid user")
        @activity.instance_variable_set("@#{k}", v)
      end
      
      render 'edit' and return
    end
    
    Strategy.live.each do |s|
      @activity.activity_strategies.find_or_create_by_strategy_id(s.id)
    end
    @activity.activity_strategies.each do |s|
      s.destroy if s.strategy.retired?
    end
    if @activity.update_attributes(params[:activity])
      flash[:notice] = "#{@activity.name} was updated."
      Mailer.activity_created(@activity).deliver if @activity.ready?
      redirect_to directorate_eas_activities_path
    else
      if !@activity.errors[:completer].blank?
        @activity.errors.add(:completer_email, "An EA must have someone assigned to undergo the assessment")
      end
      if !@activity.errors[:approver].blank?
        @activity.errors.add(:approver_email, "An EA must have someone assigned to approve the assessment")
      end
      if !@activity.errors[:qc_officer].blank?
        @activity.errors.add(:qc_officer_email, "An EA must have someone assigned as a Quality Control Officer for the assessment")
      end
      @service_areas = ServiceArea.active.where(:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id))
      render "edit"
    end
  end
  
  def submit
    #TODO: setup approver
    if @activity.completed
      @activity.submitted = true
      @activity.save!
      Mailer.activity_submitted(@activity, params[:email_contents]).deliver
      flash[:notice] = 'Your EA has been successfully submitted for approval.'
    else
      flash[:error] = "You need to finish your EA before you can submit it."
    end
    redirect_to questions_activity_path(@activity)
  end

  # Opening page where they must choose between Activity/Policy and Existing/Proposed
  # Available to: Activity Manager
  def questions
    @selected = "my_eas"
    @breadcrumb = [["My EAs", my_eas_activities_path], ["#{@activity.name}"]]
    completed_status_array = @activity.strands(true).map{|strand| [strand.to_sym, @activity.completed(nil, strand)]}
    completed_status_hash = Hash[*completed_status_array.flatten]
    tag_test = completed_status_hash.select{|k,v| !v}.map(&:first).map do |strand_status|
      "($('#{strand_status.to_s}_checkbox').checked)"
    end
  end
  
  def task_group
    @selected = "my_eas"
    @breadcrumb = [["My EAs", my_eas_activities_path], ["#{@activity.name} Task Group Management"]]
    @task_group_members = @activity.task_group_memberships.map(&:user)
  end

  def add_task_group_member
    render :layout => false
  end
  
  def create_task_group_member
    email = params[:activity][:task_group_member]
    @activity.task_group_member = email
    u = User.live.find_by_email(email)
    if u = User.live.find_by_email(email)
      @activity.task_group_memberships.build(:user => u)
    end
    if u && @activity.save
      render :update do |page|
        page.redirect_to task_group_activity_path(@activity)
      end
    else
      if u.blank?
        @activity.errors.add(:task_group_member, "You must enter a valid user")
      end
      if u && !@activity.errors[:task_group_memberships].blank?
        @activity.errors.add(:task_group_member, "This person has already been added to the task group.")
      end
      render "add_task_group_member", :layout => false
    end
  end
  
  def remove_task_group_member
    user = @activity.task_group_memberships.find_by_user_id(params[:user_id]).user
    @activity.task_group_memberships.find_by_user_id(params[:user_id]).destroy
    flash[:notice] = "#{user.email} was removed from this task group."
    redirect_to task_group_activity_path(@activity.id)
  end
  
  def task_group_comment_box
    render :layout => false
  end
  
  def make_task_group_comment
    Mailer.activity_task_group_comment(@activity, params[:email_contents], params[:subject], current_user).deliver
    flash[:notice] = "Your comment has been sent."
    redirect_to assisting_activities_path
  end

  def summary
    render :partial => "summary"
  end
  
  def generate_schedule
    activities = []
    if current_user.corporate_cop?
      activities = Activity.ready.where(:id => params[:activities])
    elsif current_user.directorate_cop?
      activities += Activity.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:cop_id=>current_user.id).map(&:id)}, :id => params[:activities], :ready => true)
    end
    if current_user.creator?
      activities += Activity.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id)}, :id => params[:activities], :ready => true)
    end
    activities = activities.uniq
    send_data SchedulePDFGenerator.new(activities).pdf.render, :disposition => 'inline',
      :filename => "schedule.pdf",
      :type => "application/pdf"
  end
  
  def actions
    @selected = "actions"
    service_area_list = []
    if current_user.corporate_cop?
      service_area_list += ServiceArea.active  
    elsif current_user.directorate_cop?
      service_area_list += Directorate.active.where(:cop_id=>current_user.id).map(&:service_areas).flatten.reject(&:retired)
    end
    if current_user.creator
      service_area_list += Directorate.active.where(:creator_id =>current_user.id).map(&:service_areas).flatten.reject(&:retired)
    end
    service_area_list.uniq!
    @service_areas = service_area_list.map do |sa|
      [sa, Issue.includes(:activity => :service_area).where(:service_areas => {:id => sa.id}).count]
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
    if @activity.submitted
      render :nothing => true
      return false
    end 
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
  
  def comment
    render :layout =>false
  end
  
  def submit_comment
    if @activity.submitted?
      @activity.update_attributes(:undergone_qc => true)
      Mailer.activity_comment(@activity, params[:email_contents], params[:subject]).deliver
    end
    redirect_to quality_control_activities_path
  end
  
  def submit_approval
    if @activity.undergone_qc? && @activity.submitted?
      @activity.update_attributes(:approved => true)
      Mailer.activity_approved(@activity, params[:email_contents], params[:subject]).deliver
    end
    redirect_to approving_activities_path
  end
  
  def submit_rejection
    if @activity.undergone_qc? && @activity.submitted?
      new_activity = @activity.clone
      new_activity.ready = true
      new_activity.start_date = @activity.start_date
      new_activity.end_date = @activity.end_date
      new_activity.review_on = @activity.review_on
      new_activity.save!
      # @activity.update_attributes(:submitted => false)
      Mailer.activity_rejected(@activity, params[:email_contents], params[:subject]).deliver
      @activity.update_attributes(:is_rejected => true)
    end
    redirect_to approving_activities_path
  end

protected
  
  def ensure_pdf_view
     if current_user.roles.size <= 0  || current_user.is_a?(Administrator)
      redirect_to access_denied_path
     end
  end 
  
  def set_activity
    @activity = current_user.activities.select{|a| a.id == params[:id].to_i}.first
    redirect_to access_denied_path unless @activity
  end
  
  def ensure_activity_task_group_member
    redirect_to access_denied_path unless @activity.task_group_memberships.map(&:user).include?(current_user)
  end
  
  def ensure_activity_completer
     redirect_to access_denied_path unless @activity.completer == current_user
  end
  
  def ensure_activity_quality_control
    redirect_to access_denied_path unless @activity.qc_officer == current_user
  end
  
  def ensure_activity_approver
     redirect_to access_denied_path unless @activity.approver == current_user
  end
  
  def ensure_activity_editable
    redirect_to access_denied_path if @activity.ready?
  end
end
