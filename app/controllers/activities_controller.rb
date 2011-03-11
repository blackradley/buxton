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
  before_filter :ensure_creator, :only => [:edit, :new, :create, :update, :directorate_einas, :view_pdf]
  before_filter :ensure_completer, :only => [:questions, :submit, :update_activity_type, :toggle_strand, :submit, :my_einas, :view_pdf]
  before_filter :ensure_approver, :only => [:view_pdf, :assisting]
  before_filter :set_activity, :only => [:questions, :update, :submit, :update_activity_type, :toggle_strand, :submit]
  
  def index
    redirect_to root_path
  end
  
  def directorate_einas
    @breadcrumb = [["Activities"]]
    @activities = Activity.all
  end
  
  def my_einas
    @breadcrumb = [["Activities"]]
    @activities = Activity.where(:completer_id => current_user.id)
  end
  
  def assisting
    @breadcrumb = [["Activities"]]
    @activities = Activity.where(:approver_id => current_user.id)
  end
  
  # Show the summary information for a specific activity.
  # Available to: Activity Manager
  def show
    ## Looks strange, but significantly reduces SQL statements in calls to answer() in views
    questions = Question.where(:activity_id => @activity.id).includes(:comment).map{|q| [q, q.comment]}
    # questions = Question.find_all_by_activity_id(@activity.id, :include => :comment).map{|q| [q, q.comment]}
    @activity_questions = {}
    questions.each do |question, comment|
      @activity_questions[question.name] = [question, comment]
    end
    org_strategies = @activity.organisation.organisation_strategies
     @activity_org_strategies = Array.new(org_strategies.size) do |i|
       @activity.activity_strategies.find_or_create_by_strategy_id(org_strategies[i].id)
     end
     dir_strategies = @activity.directorate.directorate_strategies
     @activity_dir_strategies = Array.new(dir_strategies.size) do |i|
       @activity.activity_strategies.find_or_create_by_strategy_id(dir_strategies[i].id)
     end
    @relevant_strands_string = @activity.relevant_strands.map!{|s| strand_display(s).titlecase}.join(', ')
    @projects = @activity.projects
  end
  

  # Create a new Activity and a new associated user, all activities must have single a valid User.
  # Available to: Organisation Manager
  def new
    @activity = Activity.new
    @activity_manager = @activity.build_activity_manager
    @activity_approver = @activity.build_activity_approver
    @activity_approver.email = @current_user.email
    directorates = @current_user.organisation.directorates
    @activity_creator = @current_user.organisation.activity_creator
    @activity_creator_url = @activity_creator.url_for_login(request) if @activity_creator
    @directorates = directorates.collect{ |d| [d.name, d.id] }
    @projects = @current_user.organisation.projects
    # If the params
    if params[:directorate] && directorate = directorates.find_by_id(params[:directorate]) then
      @activity.directorate = directorate
    end
  end

  # Create a new activity and a new user based on the parameters in the form data.
  # Available to: Organisation Manager
  def create
    @project_ids = (params[:projects].nil? ? [] : params[:projects])
    @projects = @current_user.organisation.projects
    @activity = Activity.new(params[:activity])
    @activity_manager = @activity.build_activity_manager(params[:activity_manager])
    @activity_manager.passkey = ActivityManager.generate_passkey(@activity_manager)
    @directorates = @current_user.organisation.directorates.collect{ |d| [d.name, d.id] } # Needed for the new template incase we need to re-render it
    @activity_approver = @activity.build_activity_approver(params[:activity_approver])
    @activity_approver.passkey = ActivityApprover.generate_passkey(@activity_approver)
    @project_ids.each do |p_id|
      @activity.projects << Project.find(p_id)
    end
    Activity.transaction do
      @activity.save!
      log_event('Create', %Q[The <strong>#{@activity.name}</strong> activity was created for <strong>#{@activity.organisation.name}</strong>.])
      flash[:notice] = "#{@activity.name} was created."
      if @current_user.class.name == 'ActivityCreator' then
        redirect_to :action => 'login', :controller => 'users', :passkey => @activity_manager.passkey
      else
        redirect_to :action => :show_by_status, :tab => 'incomplete'
      end
    end
  end

  # Update the activity details accordingly.
  # Available to: Activity Manager
  def update
    @activity.update_attributes!(params[:activity])

    flash[:notice] = "#{@activity.name} was successfully updated."
    redirect_to :controller => 'activities', :action => 'show'

  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
    flash[:notice] =  "Could not update the activity."
    render :action => :show
  end
  
  def submit
    @user = @current_user.activity.activity_approver
    @activity.approved = "submitted"
    @activity.save
    @login_url = @user.url_for_login(request)
    email = Notifier.create_approver_key(@user, @login_url)
    Notifier.deliver(email)
    @user.reminded_on = Time.now
    @user.save
    flash[:notice] = 'Your activity has been successfully submitted for approval.'
    redirect_to :controller => 'activities', :action => 'show'
  end
  
  def approve
    @activity = @current_user.activity
    @activity.approved = "approved"
    @activity.save
    redirect_to :controller => 'activities', :action => 'show'
  end
  
  def unapprove
    @activity = @current_user.activity
    @activity.approved = "submitted"
    @activity.save
    redirect_to :controller => 'activities', :action => 'questions'
  end
  
  def unsubmit
    @activity = @current_user.activity
    @activity.approved = "not submitted"
    @activity.save
    redirect_to :controller => 'activities', :action => 'questions'
  end

  # Opening page where they must choose between Activity/Policy and Existing/Proposed
  # Available to: Activity Manager
  def questions
    @breadcrumb = [["Activities", activities_path], ["#{@activity.name}"]]
    completed_status_array = @activity.strands(true).map{|strand| [strand.to_sym, @activity.completed(nil, strand)]}
    completed_status_hash = Hash[*completed_status_array.flatten]
    tag_test = completed_status_hash.select{|k,v| !v}.map(&:first).map do |strand_status|
      "($('#{strand_status.to_s}_checkbox').checked)"
    end
    @tag_test = "#{tag_test.join('||')}"
    @tag_test = true  if @tag_test.blank?
    @conditional_flip = if @current_user.class.name == 'ActivityApprover' then
      "(#{@tag_test}) ? Element.hide('approve_now') : Element.show('approve_now');"
     elsif @current_user.class.name == 'ActivityManager'
      "(#{@tag_test}) ? Element.hide('four') : Element.show('four');"
     end
     puts @conditional_flip.inspect
  end

  # Update the activity status and proceed, or not, accordingly
  # Available to: Activity Manager
  def update_activity_type
    @activity.update_attributes!(params[:activity])

    # Check both the Activity/Policy and Existing/Proposed questions have been answered
    if @activity.started then
      # If so, proceed
      flash[:notice] =  "#{@activity.name} status was successfully set up."
    else
      # If not, take them back and give them a chance to answer again
      flash[:notice] =  "Please answer both questions before proceeding."
    end

    redirect_to :action => 'questions'

  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
    flash[:notice] =  "Could not update the activity."
    render :action => :questions
  end
  
  def view_pdf
    if @current_user.class.name =~ /Activity/ then
      @activity = @current_user.activity
    elsif @current_user.respond_to?(:activities)
      @activity = @current_user.activities.find(params[:id])
    else
      raise ActiveRecord::RecordNotFound
    end
    type = params[:type]
    log_event('PDF', %Q[The activity manager PDF for the <strong>#{@activity.name}</strong> activity, within <strong>#{@activity.organisation.name}</strong>, was viewed.])
    send_data ActivityPDFGenerator.new(@activity, type).pdf.render, :disposition => 'inline',
      :filename => "#{@activity.name}.pdf",
      :type => "application/pdf"
  end

  def toggle_strand
    @activity.toggle("#{params[:strand]}_relevant")
    @activity.save!
    render :nothing => true
  end
  
  
protected


  def ensure_activity_manager
    redirect_to access_denied_path if (["ActivityManager"] & current_user.roles).blank?
  end
  
  def ensure_activity_approver
    
  end
  
  def set_activity
    @activity = current_user.activities.select{|a| a.id == params[:id].to_i}.first
  end
end
