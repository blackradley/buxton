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

  before_filter :deny_admins
  # before_filter :ensure_can_create_eas, :only => [:my_eas, :edit, :new, :create, :update]
  before_filter :ensure_creator, :only => [:directorate_eas]
  before_filter :ensure_dgo, :only => [:directorate_governance_eas]
  before_filter :set_activity, :only => [:edit, :task_group, :add_task_group_member, :remove_task_group_member, :create_task_group_member,
                                          :questions, :update, :toggle_strand, :submit, :show, :delete, :destroy, :approve, :reject, :submit_approval, :submit_rejection,
                                          :task_group_comment_box, :make_task_group_comment, :summary, :comment, :submit_comment, :clone]
  before_filter :ensure_completer, :only => [:task_group, :add_task_group_member, :remove_task_group_member, :create_task_group_member]
  before_filter :ensure_activity_completer, :only => [:questions, :submit, :toggle_strand]
  before_filter :ensure_approver, :only => [:approving]
  before_filter :ensure_task_group_member, :only => [:assisting]
  before_filter :ensure_quality_control, :only => [:quality_control]
  before_filter :ensure_activity_task_group_member, :only => [:task_group_comment_box, :make_task_group_comment]
  before_filter :ensure_activity_quality_control, :only => [:comment, :submit_comment]
  before_filter :ensure_activity_approver, :only => [:approve, :submit_approval]
  before_filter :ensure_activity_editable, :only => [:edit, :update]
  before_filter :ensure_activity_approver_or_qc, :only => [:reject, :submit_rejection]
  before_filter :ensure_not_approved, :only => [:add_task_group_member, :remove_task_group_member, :create_task_group_member, :submit_approval, :submit_rejection, :submit, :task_group_comment_box, :make_task_group_comment, :comment, :submit_comment]

  autocomplete :user, :email, :scope => :live

  def index
    # if current_user.email=='shaun@27stars.co.uk'
    #   @activities = Activity.all
    #   render :my_eas
    # else
      redirect_to root_path
    # end
  end

  def directorate_eas_activities_path
    @breadcrumb = [["Directorate EAs"]]
    @directorates = current_user.count_directorates
    @live_directorates = current_user.count_live_directorates
    @service_areas = ServiceArea.active.where(:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id))
    @activities = Activity.active.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id)})
    @selected = "directorate_eas"
  end

  def my_eas
    @breadcrumb = [["Task Group Manager"]]
    @activities = Activity.where(:completer_id => current_user.id, :ready => true)
    @activities += current_user.directorates.map(&:activities).flatten
    @activities = @activities.uniq
    @selected = "my_eas"
    @creatable = ServiceArea.count > 0
  end

  def clone
    original_activity = Activity.find(params[:id])
    @breadcrumb = [["My EAs", my_eas_activities_path], ["Clone #{original_activity.name}"]]
    @selected = "directorate_eas"
    @directorates = Directorate.all.select{|d| d.service_areas.count > 0}
    @activity = Activity.new(original_activity.attributes)
    @clone_of = original_activity
    @activity.approved = false
    @activity.submitted = false
    @activity.actual_start_date = nil
    @activity.review_on = nil
    @activity.service_area_id = @clone_of.service_area_id
    @service_areas = @clone_of.service_area.directorate.service_areas
    render :new
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
    @activities = Activity.where( :directorate_id => current_user.directorates.map(&:id) )
    @activities = Activity.joins( :service_area ).where( :service_areas => { :directorate_id => current_user.directorates.map(&:id) } )
    unless params[ :view_approved ]
      @activities =  @activities.select{|x| !x.approved?}
    end
    # unless current_user.corporate_cop?
    #   @activities = []
    #   if current_user.creator?
    #     @activities += Activity.active.ready.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id)}, :ready => true)
    #   end
    #   @activities += current_user.cop_activities.where(:ready => true )
    #   #@activities += Activity.active.ready.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:cop_id=>current_user.id).map(&:id)}, :ready => true)
    # end
    @selected = "ea_governance"
  end

  def new
    # @directorates = Directorate.where(:creator_id=>current_user.id)
    @breadcrumb = [["My EAs", my_eas_activities_path], ["New EA"]]
    @directorates = Directorate.active.select{|d| d.service_areas.count > 0}
    @service_areas = @directorates.first.service_areas
    @selected = "directorate_eas"
    @activity = Activity.new
    # @activity.service_area = @service_areas.first
    @activity.approver = @service_areas.first.approver if @service_areas.first #Default approver
  end

  def create
    @breadcrumb = [["My EAs", my_eas_activities_path], ["New EA"]]
    @directorates = Directorate.active.select{|d| d.service_areas.count > 0}

    # @service_areas = ServiceArea.active.where(:directorate_id => Directorate.active.where(:creator_id=>current_user.id, :retired =>false).map(&:id))
    @selected = "directorate_eas"
    invalid = params[:activity].select{|k,v| k.match(/_email/) && !v.blank? && !User.live.exists?(:email => v)}#.each do |k,v|
    unless invalid.empty?
      @activity = Activity.new(params[:activity])
      @activity.ready = true
      invalid.each do |k,v|
        @activity.errors.add(k, "is not a valid user")
        @activity.instance_variable_set("@#{k}", v)
      end
      @service_areas = Directorate.find(params[:activity][:directorate]).service_areas
      # @service_areas = ServiceArea.active.where(:directorate_id => Directorate.where(:creator_id=>current_user.id).map(&:id))
      render 'new' and return
    end
    [:completer_id, :approver_id, :qc_officer_id].each{|p| params[:activity].delete(p)}
    if params[:clone_of]
      @activity = current_user.activities.find(params[:clone_of])
      # unless @activity
      #   flash[:notice] = "The Service Area for this EA has been retired and therefore this EA cannot be cloned."
      #   if current_user.creator?
      #     redirect_to directorate_eas_activities_path and return
      #   else
      #     redirect_to my_eas_activities_path and return
      #   end
      # else
        if Activity.new(params[:activity]).valid?
          @activity = @activity.clone
          @activity.actual_start_date = nil
        else
          a = Activity.new(params[:activity])

          @breadcrumb = [["My EAs", my_eas_activities_path], ["Clone #{@activity.name}"]]
          @selected = "directorate_eas"
          @directorates = Directorate.all.select{|d| d.service_areas.count > 0}
          @clone_of = @activity
          @activity = Activity.new(@activity.attributes)
          @activity.approved = false
          @activity.submitted = false
          @activity.actual_start_date = nil
          @activity.review_on = nil
          @activity.service_area_id = @clone_of.service_area_id
          @service_areas = @clone_of.service_area.directorate.service_areas
          @activity.errors = a.errors
          @activity.update_attributes( params[:activity] )
          render :new and return
        end
      # end
    else
      @activity = Activity.new()
    end
    Strategy.live.each do |s|
      @activity.activity_strategies.build(:strategy => s) unless @activity.activity_strategies.map(&:strategy).include?(s)
    end
    @activity.ready = true
    @breadcrumb = [["My EAs", my_eas_activities_path], ["New EA"]]
    @selected = "directorate_eas"
    if @activity.update_attributes(params[:activity])
      flash[:notice] = "#{@activity.name} was created."
      @activity.generate_ref_no# unless params[:clone_of]
      Mailer.activity_created(@activity).deliver_now if @activity.ready?
      # if current_user.creator?
      #   redirect_to directorate_eas_activities_path and return
      # else
        redirect_to my_eas_activities_path and return
      # end
    else
      if @activity.errors[:completer].present?
        @activity.errors.add(:completer_email, "Task Group Manager " + @activity.errors[:completer].to_sentence)
      end
      if @activity.errors[:approver].present?
        @activity.errors.add(:approver_email, "Senior Officer " + @activity.errors[:approver].to_sentence)
      end
      if @activity.errors[:qc_officer].present?
        @activity.errors.add(:qc_officer_email, "Quality Control Officer " + @activity.errors[:qc_officer].to_sentence)
      end
      @service_areas = Directorate.find(params[:activity][:directorate]).service_areas

      # @service_areas = ServiceArea.active.where(:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id))
      render 'new'
    end
  end

  def destroy
    flash[:notice] = "#{@activity.name} has been permanently deleted."
    @activity.destroy
    redirect_to my_eas_activities_path
  end

  def edit
    @breadcrumb = [["My EAs", my_eas_activities_path], ["Edit EA"]]
    @activity = Activity.find(params[:id])
    @directorates = Directorate.all.select{|d| d.service_areas.count > 0}
    @directorate = @activity.directorate
    @service_areas = @directorate.service_areas if @directorate

    @selected = "directorate_eas"
  end

  def edit_tgm
    @breadcrumb = [["My EAs", my_eas_activities_path], ["Edit EA"]]
    @activity = Activity.find(params[:id])
    @selected = "directorate_eas"
  end

  # Update the activity details accordingly.
  # Available to: Activity Manager
  def update
    @directorates = Directorate.all.select{|d| d.service_areas.count > 0}
    @directorate = @activity.directorate
    @service_areas = @directorate.service_areas if @directorate
    @breadcrumb = [["My EAs", my_eas_activities_path], ["New EA"]]

    @selected = "directorate_eas"
    # @service_areas = ServiceArea.active.where(:directorate_id => Directorate.active.where(:creator_id=>current_user.id, :retired =>false).map(&:id))
    @activity = Activity.find(params[:id])
    [:completer_id, :approver_id, :qc_officer_id].each{|p| params[:activity].delete(p)}
    invalid = params[:activity].select{|k,v| k.match(/_email/) && !v.blank? && !User.live.exists?(:email => v)}#.each do |k,v|
    unless invalid.empty?
      invalid.each do |k,v|
        @activity.errors.add(k, "is not a valid user")
        @activity.instance_variable_set("@#{k}", v)
      end

      render 'edit' and return
    end

    Strategy.live.each do |s|
      @activity.activity_strategies.find_or_create_by(strategy_id: s.id)
    end
    @activity.activity_strategies.each do |s|
      s.destroy if s.strategy && s.strategy.retired?
    end
    if @activity.update_attributes(params[:activity])
      flash[:notice] = "#{@activity.name} was updated."
      Mailer.activity_created(@activity).deliver_now if @activity.ready?
      if current_user.creator?
        redirect_to directorate_eas_activities_path and return
      else
        redirect_to my_eas_activities_path and return
      end
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
      # @service_areas = ServiceArea.active.where(:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id))
      render "edit"
    end
  end

  def update_tgm
    @breadcrumb = [["My EAs", my_eas_activities_path], ["New EA"]]
    @selected = "directorate_eas"
    @activity = Activity.find(params[:id])

    if @activity.update_attributes(params[:activity])
      flash[:notice] = "#{@activity.name} was updated."
      # Mailer.activity_created(@activity).deliver_now if @activity.ready?
      redirect_to directorate_governance_eas_activities_path and return
    else
      if !@activity.errors[:completer].blank?
        @activity.errors.add(:completer_email, "An EA must have someone assigned to undergo the assessment")
      end
      render "edit_tgm"
    end
  end

  def submit
    #TODO: setup approver
    if @activity.completed
      @activity.submitted = true
      @activity.save!
      Mailer.activity_submitted(@activity, params[:email_contents]).deliver_now
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
    @breadcrumb = [["Task Group Manager", my_eas_activities_path], ["#{@activity.name}"]]
    completed_status_array = @activity.strands(true).map{|strand| [strand.to_sym, @activity.completed(nil, strand)]}
    completed_status_hash = Hash[*completed_status_array.flatten]
    @activity.update_attributes( :actual_start_date => Date.today() ) if @activity.actual_start_date.blank? && @activity.started
    tag_test = completed_status_hash.select{|k,v| !v}.map(&:first).map do |strand_status|
      "($('#{strand_status.to_s}_checkbox').checked)"
    end
  end

  def task_group
    @selected = "my_eas"
    @breadcrumb = [["Task Group Manager", my_eas_activities_path], ["#{@activity.name} Task Group Management"]]
    @task_group_members = @activity.task_group_memberships.map(&:user)
  end

  def add_task_group_member
    render :layout => false
  end

  def create_task_group_member
    email = params[:activity][:task_group_member]
    @activity.task_group_member = email
    u = User.live.find_by(email: email)
    if u
      @activity.task_group_memberships.build(:user => u)
    end
    if u && @activity.save
      Mailer.activity_task_group_member_added(@activity,u).deliver_now
      render :text => "form load successful",:content_type => 'text/plain'
      # render :update do |page|
      #   page.redirect_to task_group_activity_path(@activity)
      # end
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
    user = @activity.task_group_memberships.find_by(user_id: params[:user_id]).user
    @activity.task_group_memberships.find_by(user_id: params[:user_id]).destroy
    Mailer.activity_task_group_member_removed(@activity,user).deliver_now
    flash[:notice] = "#{user.email} was removed from this task group."
    redirect_to task_group_activity_path(@activity.id)
  end

  def task_group_comment_box
    render :layout => false
  end

  def make_task_group_comment
    Mailer.activity_task_group_comment(@activity, params[:email_contents], params[:cc], params[:subject], current_user).deliver_now
    flash[:notice] = "Your comment has been sent."
    redirect_to assisting_activities_path
  end

  def summary
    render :partial => "summary"
  end

  def generate_schedule
    @activities =  Activity.where(:id => params[ :activities ] )
    # activities = []
    # if current_user.corporate_cop?
    #   activities = Activity.ready.where(:id => params[:activities])
    # elsif current_user.directorate_cop?
    #   activities += Activity.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:cop_id=>current_user.id).map(&:id)}, :id => params[:activities], :ready => true)
    # end
    # if current_user.creator?
    #   activities += Activity.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id)}, :id => params[:activities], :ready => true)
    # end
    # activities = activities.uniq
    send_data ScheduleCSVGenerator.new(@activities).csv,
      :filename => "schedule.csv",
      :type => "text/csv"
  end

  ########this is the old pdf version, just in case they ever want it back
  # def generate_schedule
  #   activities = []
  #   if current_user.corporate_cop?
  #     activities = Activity.ready.where(:id => params[:activities])
  #   elsif current_user.directorate_cop?
  #     activities += Activity.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:cop_id=>current_user.id).map(&:id)}, :id => params[:activities], :ready => true)
  #   end
  #   if current_user.creator?
  #     activities += Activity.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:creator_id=>current_user.id).map(&:id)}, :id => params[:activities], :ready => true)
  #   end
  #   activities = activities.uniq
  #   send_data SchedulePDFGenerator.new(activities).pdf.render, :disposition => 'inline',
  #     :filename => "schedule.pdf",
  #     :type => "application/pdf"
  # end

  def actions
    @selected = "actions"
    service_area_list = []
    if current_user.corporate_cop?
      service_area_list += ServiceArea.active
    elsif current_user.directorate_cop?
      service_area_list += Directorate.active.select{|z| z.cops.include?(self)}.map(&:service_areas).flatten.reject(&:retired)
    end
    if current_user.creator
      # service_area_list += Directorate.active.where(:creator_id =>current_user.id).map(&:service_areas).flatten.reject(&:retired)
    end
    service_area_list.uniq!
    @service_areas = service_area_list.map do |sa|
      [sa, sa.activities.map(&:relevant_action_count).sum]
    end
  end

  def show
    type = params[:type]
    PDFLog.create(:activity => @activity, :user => current_user)
    #log_event('PDF', %Q[The PDF for the <strong>#{@activity.name.html_safe}</strong> EA, within directorate <strong>#{@activity.directorate.name}</strong>, was viewed by #{current_user.email}])
    send_data ActivityPDFGenerator.new(@activity, type).pdf.render, :disposition => 'inline',
      :filename => "#{@activity.name}.pdf",
      :type => "application/pdf"
  end

  def toggle_strand
    # if @activity.submitted
    #   render :nothing => true
    #   return false
    # end
    unless @activity.strand_required?(params[:strand])
      @activity.toggle("#{params[:strand]}_relevant")
      @activity.save!
    end
    render :nothing => true
  end

  def delete
    render :layout =>false
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
      flash[:notice] = "Successfully performed Quality Control on #{@activity.name}"
      Mailer.activity_comment(@activity, params[:email_contents], params[:subject]).deliver_now
    end
    redirect_to quality_control_activities_path
  end

  def submit_approval
    if @activity.undergone_qc? && @activity.submitted?
      @activity.update_attributes(:approved => true, :approved_on => Date.today() )
      flash[:notice] = "Successfully approved #{@activity.name}"
      Mailer.activity_approved(@activity, params[:email_contents], params[:subject]).deliver_now
    end
    redirect_to approving_activities_path
  end

  def submit_rejection
    if @activity.submitted?
      new_activity = @activity.clone
      new_activity.ready = true
      new_activity.review_on = @activity.review_on
      new_activity.recently_rejected = true
      new_activity.save!
      # @activity.update_attributes(:submitted => false)
      flash[:notice] = "#{@activity.name} rejected."
      Mailer.activity_rejected(@activity, params[:email_contents], params[:subject], params[:cc]).deliver_now
      @activity.update_attributes(:is_rejected => true, :previous_activity_id => new_activity.id)
    end
    if @activity.undergone_qc
      redirect_to approving_activities_path
    else
      redirect_to quality_control_activities_path
    end
  end

  def get_service_areas
    @service_areas = ServiceArea.where(directorate_id: params[ :directorate_id ].to_i ).select{|z| z.retired == false }
    render :layout => false
  end

protected

  def set_activity
    if current_user.completer?# || current_user.is_a?(Administrator)
      @activity = Activity.find( params[:id] );
    else
      @activity = current_user.activities.detect{|a| a.id == params[:id].to_i}
    end
    redirect_to access_denied_path unless @activity
  end

  def ensure_can_create_eas
    redirect_to access_denied_path unless current_user.completer? || current_user.creator?
  end

  def ensure_dgo
    redirect_to access_denied_path unless current_user.roles.include?( "Directorate Cop" )
  end

  def ensure_activity_task_group_member
    redirect_to access_denied_path unless @activity.task_group_memberships.map(&:user).include?(current_user)
  end

  def ensure_activity_completer
     redirect_to access_denied_path unless @activity.completer == current_user || @activity.task_group_memberships.map(&:user_id).include?( current_user.id )
  end

  def ensure_activity_quality_control
    redirect_to access_denied_path unless (@activity.qc_officer == current_user) && @activity.submitted && !@activity.undergone_qc
  end

  def ensure_activity_approver
     redirect_to access_denied_path unless @activity.approver == current_user
  end

  def ensure_activity_editable
    redirect_to access_denied_path if @activity.approved?
  end

  def ensure_not_approved
    redirect_to access_denied_path if @activity.approved
  end

  def ensure_activity_approver_or_qc
    redirect_to access_denied_path unless @activity.approver == current_user || @activity.qc_officer == current_user
  end

end
