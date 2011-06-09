class Mailer < ActionMailer::Base
  default :from => 'support@blackradley.com'
  
  default_url_options[:host] = case Rails.env
                               when 'production'
                                 'birmingham.impactequality.co.uk'
                               when 'staging'
                                 'birmingham.27stars.co.uk'
                               when 'preview'
                                 'preview.impactequality.co.uk'
                               else
                                 'localhost:3000'
                               end
  
  
  def activity_created(activity)
    @activity = activity
    mail(:to => [@activity.completer, @activity.qc_officer].uniq.map(&:email).join(", "),
         :subject => "A new EA has been created")
    #mail completer
  end
  
  def activity_completed(activity)
    
    #mail checker
  end
  
  
  def activity_task_group_comment(activity, email_contents)
    @activity = activity
    @contents = email_contents
    mail(:to => activity.email_targets,
         :subject => "EA #{@activity.name} Reference ID #{@activity.ref_no} has been commented on")
  end
  
  def new_account(user, password)
    @user     = user
    @password = password
    mail(:to => user.email,
         :subject => "Welcome to the EA Toolkit")
  end
  
  def activity_submitted(activity, email_contents)
    @activity = activity
    @contents = email_contents
    mail(:to => "#{activity.completer.email}, #{activity.qc_officer.email}, #{activity.approver}",
         :subject => "EA #{@activity.name} Reference ID #{@activity.ref_no} has been submitted for quality control")
  end
  
  def password_reset(user, password)
    @user = user
    @password = password
    mail(:to => user.email,
         :subject => "Your password has been successfully reset")
  end


  def activity_approved(activity, email_contents)
    @activity = activity
    @contents = email_contents
    mail(:to => [@activity.completer, @activity.qc_officer].uniq.map(&:email).join(", "),
         :subject => "EA #{@activity.name} Reference ID #{@activity.ref_no} has been approved")
  end
  
  
  def activity_comment(activity, email_contents)
    @activity = activity
    @contents = email_contents
    mail(:to => activity.email_targets,
         :subject => "EA #{@activity.name} Reference ID #{@activity.ref_no} has undergone quality control")
  end
  
  def activity_rejected(activity, email_contents)
    @activity = activity
    @contents = email_contents
    mail(:to => [@activity.completer, @activity.qc_officer].uniq.map(&:email).join(", "),
         :subject => "EA #{@activity.name} Reference ID #{@activity.ref_no} has been rejected")
  end
end
