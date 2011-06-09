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
  
  def activity_task_group_comment(activity, email_contents, subject, user)
    @activity = activity
    @contents = email_contents
    mail(:to => activity.completer.email,
        :cc => activity.task_group_memberships.map(&:user).map(&:email).join(", ")
          :reply_to => user.email,
         :subject => subject)
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
    mail(:to => @activity.qc_officer.email,
         :cc => [@activity.approver, @activity.completer].uniq.map(&:email).join(", ")
         :reply_to => @activity.completer.email,
         :subject => "EA #{@activity.name} Reference ID #{@activity.ref_no} has been submitted for quality control")
  end
  
  def password_reset(user, password)
    @user = user
    @password = password
    mail(:to => user.email,
         :subject => "Your password has been successfully reset")
  end


  def activity_approved(activity, email_contents, subject)
    @activity = activity
    @contents = email_contents
    mail(:to => @activity.completer.email
         :cc => @activity.qc_officer.email
         :reply_to => @activity.approver.email,
         :subject => subject)
  end
  
  
  def activity_comment(activity, email_contents, subject)
    @activity = activity
    @contents = email_contents
    mail(:to => activity.approver.email,
         :cc => (activity.associated_users - [activity.approver]).uniq.map(&:email).join(", ")
         :reply_to => @activity.qc_officer.email,
         :subject => subject)
  end
  
  def activity_rejected(activity, email_contents, subject)
    @activity = activity
    @contents = email_contents
    mail(:to => @activity.completer.email
         :cc => @activity.qc_officer.email
         :reply_to => @activity.approver.email,
         :subject => subject)
  end
end
