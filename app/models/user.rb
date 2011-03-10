class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :roles, :activities
  has_many :activities
  serialize :roles
  
  after_initialize :include_roles
  after_create :include_roles
  
  
  def include_roles
    #don't include the roles if it hasn't been created yet. The after create will add them in that instance
    return true if self.new_record?
    self.roles.to_a.each do |role|
      self.class_eval("include #{role.classify}")
    end
  end
  
  
  def term(term)
    assoc_term = Terminology.find_by_term(term)
    terminology = Organisation.first.organisation_terminologies.find_by_terminology_id(assoc_term.id)
    terminology ? terminology.value : term
  end
  
  def creator?
    false
  end
  
  def activity_manager?
    false
  end
  
end
