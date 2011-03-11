class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :roles, :activities, :retired, :locked, :trained
  serialize :roles
  before_create :setup_roles
  scope :live, :conditions => "type is null"
  
  def setup_roles
    self.roles ||=[]
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
  
  def ordered_roles
    ["Creator", "Completer", "Approver", "Checker", "Cop"].select{|role| self.roles.include? role}
  end
  
  def creator?
    self.roles.include?("Creator")
  end
  
  def completer?
    self.roles.include?("Completer")
  end
  
  def approver?
    self.roles.include?("Approver")
  end
end
