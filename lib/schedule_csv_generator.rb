#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
require 'csv'

class SchedulePDFGenerator

  def initialize(activities)
    @activities = activities
  end

  def pdf
    path = 'tmp/schedule'
    CSV.open(path, "wb") do |csv|
      csv << ["Directorate", "Service Area", "EA Reference", "EA Title", "Task Group Leader", "Senior Officer/Approver", "Quality Control Officer", "Status", "Progress", "Date Started", "Completion Date", "No. of Actions", "Action Plan Complete?"]
      activities.each do |ac|
        csv << [ac.directorate.name, ac.service_area.name, ac.ref_no, ac.name, ac.completer.email, ac.approver.email, ac.qc_officer.email, ac.activity_status_name, ac.full_progress, ac.actual_start_date, activity.approved_on ? activity.approved_on.to_s(:full) : "", , activity.action_plan_completed ]
      end
    end
    
    table = []
    heading_row = ["Service Area", "Reference", "Task Group Leader", "Name", "Status", "Progress", "Completion Date", "Relevant", "Action Plan Complete?"]
    table << heading_row
    @activities.each do |activity|
      approved_date = activity.approved_on ? activity.approved_on.to_s(:full) : ""
      table << [activity.service_area.name, activity.ref_no, activity.completer.email, activity.name, activity.activity_status_name, activity.full_progress, approved_date, activity.activity_relevant? ? "Yes" : "No", activity.action_plan_completed]
    end
    @pdf = generate_table(@pdf, table, :borders => [60,120,180,240,300,360,420,480,540],:row_format => [{:shading => SHADE_COLOUR}, nil])
    @pdf
  end

end
