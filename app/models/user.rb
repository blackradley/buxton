class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :trackable, :validatable, :timeoutable, :lockable , :recoverable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :roles, :activities, :retired, :locked, :trained, :creator
  scope :live, :conditions => "type is null and retired is not true"
  scope :non_admin, :conditions => "type is null"
  scope :non_retired, :conditions => "retired is not true"
  scope :creator, :conditions => "creator is true and type is null and retired is not true"
  before_validation(:on => :create) { self.set_password }
  after_create :send_password
  before_save :update_lock_time
  before_save :log_failed_attempts
  has_many :task_group_memberships
  
  def cop_email
    #required for directorate autocomplete hack
    self.email
  end
  
  def set_password
    @new_pass = String.random_alphanumeric
    self.password = @new_pass
    self.password_confirmation = @new_pass
  end
  
  def reset_password!
    @new_pass = String.random_alphanumeric
    self.password = @new_pass
    self.locked = false
    self.failed_attempts = 0
    self.password_confirmation = @new_pass
    self.save
    Mailer.password_reset(self, @new_pass).deliver
  end
  
  def count_directorates
    Directorate.where(:creator_id => self.id).count
  end
  
  def count_live_directorates
    Directorate.where(:creator_id => self.id, :retired => false).count
  end
  
  def directorate
    Directorate.find_by_creator_id(self.id)
  end
  
  def send_password
    Mailer.new_account(self, @new_pass).deliver
  end
  
  def update_lock_time
    if locked_changed?
      if locked?
        self.locked_at = Time.now
      else
        self.locked_at = nil
      end
    end
  end
  
  def lock_access!
    self.locked = true
    super
  end
  
  def self.maximum_attempts
    2
  end
  
  def valid_for_authentication?
    was_locked = locked?
    response = super
    
    if response==:locked && was_locked
      text = %Q[<a href="mailto:#{email}">#{email}</a> failed to log in due to locked account.]
      # Log this type of event
      # CAUTION! See: http://notetoself.vrensk.com/2008/08/escaping-single-quotes-in-ruby-harder-than-expected/
      # for why we're escaping this this way
      escaped_text = text.gsub(/\\|'/) { |c| "\\#{c}" }
      FailedLoginLog.create(:message => escaped_text)
    end
    response
  end
  
  def log_failed_attempts
    if failed_attempts > 0 && failed_attempts_changed?
      text = %Q[<a href="mailto:#{email}">#{email}</a> failed login attempt #{failed_attempts}.]
      text << " User locked out" if locked?
      # Log this type of event
      # CAUTION! See: http://notetoself.vrensk.com/2008/08/escaping-single-quotes-in-ruby-harder-than-expected/
      # for why we're escaping this this way
      escaped_text = text.gsub(/\\|'/) { |c| "\\#{c}" }
      FailedLoginLog.create(:message => escaped_text)
    end
  end
  
  
  def activities
    self.roles.map do |role|
      case role
      when "Quality Control"
        Activity.active.where(:qc_officer_id => self.id, :ready => true, :submitted => true, :undergone_qc => false)
      when "Completer"
        Activity.active.where(:completer_id => self.id, :ready => true)
      when "Approver"
        Activity.active.where(:approver_id => self.id, :ready => true)
      when "Creator"
        Activity.active.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:creator_id=>self.id).map(&:id)})
      when "Directorate Cop"
        Activity.active.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.active.where(:cop_id=>self.id).map(&:id)})
      when "Corporate Cop"
        Activity.active
      when "Helper"
        self.task_group_memberships.map(&:activity).flatten
      end
    end.flatten.compact.uniq
  end
  
  def term(term)
    term
  end
  
  def roles
    ["Creator", "Completer", "Approver", "Corporate Cop", "Helper", "Directorate Cop", "Quality Control"].select{|role| self.send("#{role.gsub(' ', '_').downcase}?".to_sym)}
  end
  
  def completer?
    Activity.active.where(:completer_id => self.id, :ready => true).count > 0
  end
  
  def quality_control?
    Activity.active.where(:qc_officer_id => self.id, :ready => true).count > 0
  end
  
  def approver?
    Activity.active.where(:approver_id => self.id, :ready => true).reject{|a| a.progress == "NS"}.count > 0
  end
  
  def directorate_cop?
    Activity.active.includes(:service_area).where(:service_areas => {:directorate_id => Directorate.where(:cop_id=>self.id).map(&:id)}).count > 0
  end
  
  def helper?
    self.task_group_memberships.size > 0
  end
  
  protected
  
  def self.find_for_database_authentication(warden_conditions)
    warden_conditions.merge!(:retired => false)
    super
  end
  
end
