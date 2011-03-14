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
  before_filter :ensure_completer, :only => [:questions, :submit, :update_activity_type, :toggle_strand, :my_einas]
  before_filter :ensure_approver, :only => [:assisting]
  before_filter :ensure_pdf_view, :only => [:view_pdf]
  before_filter :set_activity, :only => [:edit, :questions, :update, :submit, :update_activity_type, :toggle_strand, :submit, :view_pdf]
  autocomplete :user, :email, :scope => :live
  
  def index
    redirect_to root_path
  end
  
  def directorate_einas
    @breadcrumb = [["Directorate Einas"]]
    @activities = Activity.all
  end
  
  def my_einas
    @breadcrumb = [["My Eina's"]]
    @activities = Activity.where(:completer_id => current_user.id)
  end
  
  def assisting
    @breadcrumb = [["Assisting"]]
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
  
  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(params[:activity])
    @activity.directorate = Directorate.first
    if @activity.save
      flash[:notice] = "#{@activity.name} was created."
      # log_event('Create', %Q[The <strong>#{@activity.name}</strong> activity was created for <strong>#{@activity.organisation.name}</strong>.])
      Mailer.activity_created(@activity).deliver
      redirect_to directorate_einas_activities_path
    else
      render 'new'
    end
  end
  
  
  def edit
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
    #TODO: setup approver
    @activity.approved = "submitted"
    @activity.save
    flash[:notice] = 'Your activity has been successfully submitted for approval.'
    redirect_to questions_activity_path(@activity)
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
    @breadcrumb = [["My Eina's", my_einas_activities_path], ["#{@activity.name}"]]
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
    type = params[:type]
    # log_event('PDF', %Q[The activity manager PDF for the <strong>#{@activity.name}</strong> activity, within <strong>#{@activity.organisation.name}</strong>, was viewed.])
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
  
  def ensure_pdf_view
    current_user.creator? || current_user.approver? || current_user.completer?
  end
  
  
  def set_activity
    @activity = current_user.activities.select{|a| a.id == params[:id].to_i}.first
  end
end
