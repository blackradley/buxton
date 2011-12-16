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
  before_filter :authenticate_user!
  before_filter :set_activity
  before_filter :set_strand, :only => [:edit, :update]
  before_filter :set_selected

  # Get the activity information ready for editing using the appropriate form.
  # Available to: Activity Manager
  def edit_purpose_a
    @breadcrumb << ["Purpose and Outcomes"]
    @equality_strand = "overall"
    @activity_strategies = @activity.activity_strategies
  end
  
  def edit_purpose_b
    @breadcrumb << ["Individuals affected by this EA"]
    @equality_strand = "overall"
  end
  
  def edit_purpose_c
    @breadcrumb << ["Relevance Test"]
    @equality_strand = "overall"
  end
  
  def edit_purpose_d
    @breadcrumb << ["Initial Summary of this EA"]
    @equality_strand = "overall"
    @letter = "d"
    #question it refers to
    @question_reference = 13
    render :assessment_comments
  end
  
  def edit_full_assessment_comment
    @breadcrumb << ["Full Summary of this EA"]
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
      @impact_issues = @impact_enabled ? @activity.issues_by(:impact, @equality_strand) : []
      @consultation_issues = @consultation_enabled ? @activity.issues_by(:consultation, @equality_strand) : []
      other_issues = @activity.issues_by(:action_planning, @equality_strand)
    end
    render "edit_#{section}"
  end

  # Update the activity answers, for this particular section, as appropriate
  # Available to: Activity Manager
  def update
    # If we have issues to process
    started = @activity.started
    initially_in_ia = @activity.questions.where("name like 'purpose_%' and completed = false and needed = true AND name not like 'purpose_overall_14'").size > 0
    # if params[:activity][:issues_attributes] then
    #   #marks all previously existing issues that had their description field blanked for destruction
    #   params[:activity][:issues_attributes].each{|i| i['_destroy'] = 1 if i['description'].blank?}
    # end
    # Update the answers in the activity table
    @activity.update_attributes!(params[:activity])
    #delivers the finished initial assessment email
    if initially_in_ia && @activity.questions.where("name like 'purpose_%' and completed = false and needed = true AND name not like 'purpose_overall_14'").size == 0
      Mailer.activity_left_ia(@activity).deliver
    end
    # Update the activity strategy answers if we have any (currently only in the Purpose section)
    if params[:strategy_responses] then
      params[:strategy_responses].each do |strategy_id, strategy_response|
        activity_strategy = @activity.activity_strategies.find_or_create_by_strategy_id(strategy_id)
        activity_strategy.strategy_response = strategy_response
        activity_strategy.save!
      end
      
    end

    if !started && @activity.started
      Mailer.activity_ia_started(@activity).deliver
    end
    
    flash[:notice] =  "#{@activity.name} was successfully updated."
    redirect_to questions_activity_path(@activity)

  end
  
  def add_new_issue
    @activity.issues.create(:section => "action_planning", :description => params[:description], :strand => params[:strand])
    redirect_to edit_activities_section_path(:section => "action_planning", :equality_strand => params[:strand], :activity => @activity)
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
    if valid_equality_strands.include?(strand) or (strand == "overall")
      @equality_strand = strand
      @id = params[:id]
    else
      redirect_to access_denied_path
      return false
    end
  end
  
  def set_activity
    @activity = current_user.activities.select{|a| a.id == params[:id].to_i}.first
    if @activity.submitted
      redirect_to access_denied_path
      return false
    end 
  end
  
  def set_selected
    @selected = "my_eas"
    @breadcrumb = [["My EAs", my_eas_activities_path], ["#{@activity.name}", questions_activity_path(@activity)]]
  end
  
end



