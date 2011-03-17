class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :trackable, :validatable, :timeoutable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :roles, :activities, :retired, :locked, :trained, :creator
  scope :live, :conditions => "type is null"
  
  before_validation(:on => :create) { self.set_password }
  after_create :send_password
  before_save :update_lock_time
  
  def set_password
    @new_pass = String.random_alphanumeric
    self.password = @new_pass
    self.password_confirmation = @new_pass
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
    ["Creator", "Completer", "Approver", "Checker", "Cop"].map do |role|
      case role
      when "Completer"
        Activity.where(:completer_id => self.id)
      when "Approver"
        Activity.where(:approver_id => self.id)
      when "Creator"
        Activity.all 
      end
    end.flatten.compact.uniq
  end
  
  def term(term)
    assoc_term = Terminology.find_by_term(term)
    terminology = Organisation.first.organisation_terminologies.find_by_terminology_id(assoc_term.id)
    terminology ? terminology.value : term
  end
  
  def roles
    ["Creator", "Completer", "Approver", "Checker", "Cop"].select{|role| self.send("#{role.downcase}?".to_sym)}
  end
  
  def completer?
    Activity.where(:completer_id => self.id).count > 0
  end
  
  def approver?
    Activity.where(:approver_id => self.id).count > 0
  end
  
  def checker?
    false
  end
  
  def cop?
    false
  end
end
