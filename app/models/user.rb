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
  
  
  def activities
    self.roles.map do |role|
      case role
      when "Quality Control"
        Activity.active.where(:qc_officer_id => self.id, :ready => true)
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
      end
    end.flatten.compact.uniq
  end
  
  def term(term)
    term
  end
  
  def roles
    ["Creator", "Completer", "Approver", "Checker", "Corporate Cop", "Directorate Cop", "Quality Control"].select{|role| self.send("#{role.gsub(' ', '_').downcase}?".to_sym)}
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
  
  def checker?
    false
  end
  
  protected
  
  def self.find_for_database_authentication(warden_conditions)
    warden_conditions.merge!(:retired => false)
    super
  end
  
end
