#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class Activities::SectionsController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # TODO: reinstate this when a section can be invalidated + check it works when POSTing to itself from /update to /update
  # verify  :method => :post,
  #         :only => [ :update ],
  #         :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  # List the section status for the different activities of an Organisation
  # but don't paginate, a long list is actually more convenient for the Organisation
  # Manager to scan down.
  before_filter :authenticate_user!, :except => :new_issue
  before_filter :set_activity
  before_filter :set_strand, :only => [:edit]
  before_filter :set_selected

  # Get the activity information ready for editing using the appropriate form.
  # Available to: Activity Manager
  def edit_purpose_a
    @breadcrumb << ["What is this EINA for?"]
    @equality_strand = "overall"
    @activity_strategies = Strategy.all.map do |s|
      @activity.activity_strategies.find_or_create_by_strategy_id(s.id)
    end
  end
  
  def edit_purpose_b
    @breadcrumb << ["Individuals affected by this EINA"]
    @equality_strand = "overall"
  end
  
  def edit_purpose_c
    @breadcrumb << ["Different benefits and disadvantages of this EINA"]
    @equality_strand = "overall"
  end
  
  def edit_purpose_d
    @breadcrumb << ["Initial Summary of this EINA"]
    @equality_strand = "overall"
    @letter = "d"
    #question it refers to
    @question_reference = 13
    render :assessment_comments
  end
  
  def edit_full_assessment_comment
    @breadcrumb << ["Full Summary of this EINA"]
    @equality_strand = "overall"
    @letter = "c"
    @question_reference = 14
    render :assessment_comments
  end
  
  def edit
    section = params[:section]
    @impact_enabled =  (@activity.questions.where(:name => "impact_#{@equality_strand}_9").first.response == 1)
    @consultation_enabled = (@activity.questions.where(:name => "consultation_#{@equality_strand}_7").first.response == 1)
    if section.to_s == "action_planning"
      @impact_issues = @activity.issues_by(:impact, @equality_strand)
      @consultation_issues = @activity.issues_by(:consultation, @equality_strand)
    end
    render "edit_#{section}"
  end

  # Update the activity answers, for this particular section, as appropriate
  # Available to: Activity Manager
  def update
    # If we have issues to process
    if @activity.submitted
      flash[:notice] =  "#{@activity.name} has been submitted and cannot be altered."
      redirect_to questions_activity_path(@activity)
      return
    end
    if !@activity.actual_start_date
      @activity.actual_start_date = Date.today
    end
    if params[:activity][:issue_attributes] then
      #removes all blank elements from the array that were not there previously (ie those without id's)
      params[:activity][:issue_attributes].reject!{|i| i['description'].blank? && i['id'].nil? }
      #marks all previously existing issues that had their description field blanked for destruction
      params[:activity][:issue_attributes].each{|i| i['_destroy'] = 1 if i['description'].blank?}
    end
    # Update the answers in the activity table
    @activity.update_attributes!(params[:activity])
    # Update the activity strategy answers if we have any (currently only in the Purpose section)
    if params[:strategy_responses] then
      params[:strategy_responses].each do |strategy_id, strategy_response|
        activity_strategy = @activity.activity_strategies.find_or_create_by_strategy_id(strategy_id)
        activity_strategy.strategy_response = strategy_response
        activity_strategy.save!
      end
    end
    
    flash[:notice] =  "#{@activity.name} was successfully updated."
    redirect_to questions_activity_path(@activity)

  end
  
  def new_issue
    @section = params[:section]
    render 'new_issue', :locals => {:issue => Issue.new, :strand => params[:strand]}, :layout => false
  end
  
  
  protected
  
  def set_strand
    strand = params[:equality_strand].strip
    @completer = @activity.completer

    @equality_strand = ''
    valid_equality_strands = Activity.strands
    if valid_equality_strands.include? strand
      @equality_strand = strand
      @id = params[:id]
    else
      # throw error
      raise ActiveRecord::RecordNotFound
    end
  end
  
  def set_activity
    @activity = current_user.activities.select{|a| a.id == params[:id].to_i}.first
    return false if @activity.submitted
  end
  
  def set_selected
    @selected = "my_einas"
    @breadcrumb = [["My EINAs", my_einas_activities_path], ["#{@activity.name}", questions_activity_path(@activity)]]
  end
  
end



