#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class Activities::IssuesController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # TODO: reinstate this when a section can be invalidated + check it works when POSTing to itself from /update to /update
  # verify  :method => :post,
  #         :only => [ :update ],
  #         :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  # List the section status for the different activities of an Organisation
  # but don't paginate, a long list is actually more convenient for the Organisation
  # Manager to scan down.
  before_filter :authenticate_user!
  before_filter :set_activity, :except => [:show, :edit, :update]
  before_filter :set_issue, :only => [:show, :edit, :update]
  before_filter :set_strand, :except => [:index]
  before_filter :set_selected
  before_filter :ensure_activity_completer, :except => [:index, :show]
  # before_filter :ensure_index_access, :only => [:index, :show]

  # Get the activity information ready for editing using the appropriate form.
  # Available to: Activity Manager
  
  def index
  end

  def create
    issue = @activity.issues.create(params[:issue])
    if issue
      redirect_to edit_activities_section_path(@activity, :section => "action_planning", :equality_strand => issue.strand, :activity => @activity)
    else

    end
  end

  def new
    @issue = @activity.issues.new(:strand => params[:strand])
  end
  

  def edit
  end

  def update
    @issue.update_attributes(params[:issue])
    redirect_to edit_activities_section_path(@activity, :section => "action_planning", :equality_strand => @issue.strand, :activity => @activity)
  end

  def show
    @breadcrumb = [["EA Governance", directorate_governance_eas_activities_path], ["#{@activity.name}", questions_activity_path(@activity)], ["Issue list", activities_issues_path(:activity => @activity.id)]]
  end
  
  protected
  
  def set_strand
    @equality_strand = params[:strand] || params[:equality_strand]
  end

  def set_issue
    @issue = Issue.find(params[:id])
    @activity = @issue.activity
    unless current_user.activities.include? @activity 
      redirect_to access_denied_path
      return false
    end 
  end

  def set_activity
    @activity = Activity.find( params[:activity] )
  end
  
  def set_selected
    if @activity && @activity.completer ==  current_user
      @selected = "my_eas"
      @breadcrumb = [["Task Group Manager", my_eas_activities_path], ["#{@activity.name}", questions_activity_path(@activity)]]
    else
      @selected = "ea_governance"
      @breadcrumb = [["EA Governance", directorate_governance_eas_activities_path], ["#{@activity.name}", questions_activity_path(@activity)]]
    end
  end

  def ensure_activity_completer
     redirect_to access_denied_path unless @activity.completer == current_user
  end

  def ensure_index_access
    redirect_to access_denied_path unless @activity.completer == current_user || @activity.directorate.cops.include?( current_user ) || current_user.corporate_cop? || current_user.creator?
  end

end



