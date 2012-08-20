#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
require 'csv'

class ScheduleCSVGenerator

  def initialize(activities)
    @activities = activities
  end

  def csv
    CSV.generate do |csv|
      csv << ["Directorate", "Service Area", "EA Reference", "EA Title", "Task Group Leader", "Senior Officer/Approver", "Quality Control Officer", "Status", "Progress", "Date Started", "Completion Date", "No. of Actions", "Action Plan Complete?"]
      @activities.each do |ac|
        csv << [ac.directorate.name, ac.service_area.name, ac.ref_no, ac.name, ac.completer.email, ac.approver.email, ac.qc_officer.email, ac.activity_status_name, ac.full_progress, ac.actual_start_date, ac.approved_on ? ac.approved_on.to_s(:full) : "", ac.relevant_action_count, ac.action_plan_completed ]
      end
    end
  end

end
