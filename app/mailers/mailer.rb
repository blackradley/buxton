class Mailer < ActionMailer::Base
  SUPPORT_ADDRESSES = ['support@27stars.co.uk']
  default :from => 'support@blackradley.com', :bcc => SUPPORT_ADDRESSES
  
  default_url_options[:host] = case Rails.env
                               when 'production'
                                 'birmingham.impactequality.co.uk'
                               when 'staging'
                                 'training.impactequality.co.uk'
                               when 'preview'
                                 'preview.impactequality.co.uk'
                               else
                                 'localhost:3000'
                               end
  
  def amended_subject(subject_text)
    if Rails.env == 'preview'
      return "[#{Rails.env.upcase}] #{subject_text}" 
    elsif Rails.env == 'staging'
      return "[TRAINING] #{subject_text}"
    end
    return subject_text
  end
  
  def activity_created(activity)
    @activity = activity
    mail(:to => [@activity.completer, @activity.qc_officer, @activity.approver].uniq.map(&:email).join(", "),
         :subject => amended_subject("A new EA has been created"))
    #mail completer
  end

  def activity_ia_started(activity)
    @activity = activity
    mail(:to => @activity.approver.email,
         :cc => @activity.qc_officer.email,
         :subject => amended_subject("Initial Assessment has been started for the EA #{@activity.name} Reference ID #{@activity.ref_no}"))
  end
  
  def activity_task_group_member_added(activity, user)
    @activity = activity
    mail(:to => user.email,
         :subject => amended_subject("You have been added to a Task Group for the EA #{@activity.name} Reference ID #{@activity.ref_no} "))
  end
  
  def activity_task_group_member_removed(activity, user)
    @activity = activity
    mail(:to => user.email,
         :subject => amended_subject("You have been removed from the Task Group for the EA #{@activity.name} Reference ID #{@activity.ref_no} "))
  end
  
  def activity_left_ia(activity)
    @activity = activity
    mail(:to => @activity.qc_officer.email,
         :cc => [@activity.approver, @activity.completer].uniq.map(&:email).join(", "),
         :reply_to => @activity.completer.email,
         :subject => amended_subject("EA #{@activity.name} Reference ID #{@activity.ref_no} has completed the Initial Assessment"))
  end
  
  def activity_task_group_comment(activity, email_contents,cc, subject, user)
    @activity = activity
    @contents = email_contents
    mail(:to => activity.completer.email,
        :cc => cc,
          :reply_to => user.email,
         :subject => amended_subject(subject))
  end
  
  def new_account(user, password)
    @user     = user
    @password = password
    mail(:to => user.email,
         :subject => amended_subject("Welcome to the Equality Risk Toolkit"))
  end
  
  def activity_submitted(activity, email_contents)
    @activity = activity
    @contents = email_contents
    mail(:to => @activity.qc_officer.email,
         :cc => [@activity.approver, @activity.completer].uniq.map(&:email).join(", "),
         :reply_to => @activity.completer.email,
         :subject => amended_subject("EA #{@activity.name} Reference ID #{@activity.ref_no} has been submitted for quality control"))
  end
  
  def password_reset(user, password)
    @user = user
    @password = password
    mail(:to => user.email,
         :subject => amended_subject("Your password has been successfully reset"))
  end


  def activity_approved(activity, email_contents, subject)
    @activity = activity
    @contents = email_contents
    mail(:to => @activity.completer.email,
         :cc => [@activity.qc_officer.email, @activity.approver.email].uniq.join(", "),
         :reply_to => @activity.approver.email,
         :subject => amended_subject(subject))
  end
  
  
  def activity_comment(activity, email_contents, subject)
    @activity = activity
    @contents = email_contents
    mail(:to => activity.approver.email,
         :cc => (activity.associated_users - [activity.approver]).uniq.map(&:email).join(", "),
         :reply_to => @activity.qc_officer.email,
         :subject => amended_subject(subject))
  end
  
  def activity_rejected(activity, email_contents, subject, cc)
    @activity = activity
    @contents = email_contents
    mail(:to => @activity.completer.email,
         :cc => cc,
         :reply_to => @activity.approver.email,
         :subject => amended_subject(subject))
  end
end
