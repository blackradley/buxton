class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :roles, :activities, :retired, :locked, :trained
  has_many :activities
  serialize :roles
  before_create :setup_roles
  scope :live, :conditions => "type is null"
  
  def setup_roles
    self.roles ||=[]
  end
  
  def term(term)
    assoc_term = Terminology.find_by_term(term)
    terminology = Organisation.first.organisation_terminologies.find_by_terminology_id(assoc_term.id)
    terminology ? terminology.value : term
  end
  
  def ordered_roles
    ["Creator", "ActivityManager", "Approver", "Checker", "Cop"].select{|role| self.roles.include? role}
  end
  
  def creator?
    self.roles.include?("Creator")
  end
  
  def activity_manager?
    self.roles.include?("ActivityManager")
  end
  
  def approver?
    self.roles.include?("Approver")
  end
  
  def activity_manager_activities
    Activity.where(:activity_manager_id => self.id)
  end

  def activity_approver_activities
    Activity.where(:activity_approver_id => self.id)
  end  
  
end
