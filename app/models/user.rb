#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
# A user may be one of three types. 
# 
# * Administrative - the user has now function or organisation
# * Organisational - the user controls an organisation
# * Functional - the user controls a function
# 
# These groups are mutually exclusive.
# 
class User < ActiveRecord::Base
  has_one :organisation
  has_one :function
  validates_presence_of :email  
  validates_format_of :email,
  :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
  :message => 'email must be valid'
#
# There is no built in method for creating a GUID in Ruby
# so the UUID in MySql is called instead.
#
  def self.newUUID
    return ActiveRecord::Base.connection.select_one('select UUID()')['UUID()']
  end  
#
# Administrative users have no organisation or function to control. 
# 
  def self.find_admins
    logger.info "Admin = " + User_Type::ADMINISTRATIVE.to_s
    find(:all, :conditions => "User_Type = #{User_Type::ADMINISTRATIVE}")
  end
end
#
# A user may be one of three types. 
# 
# * Administrative - the user has now function or organisation
# * Organisational - the user controls an organisation
# * Functional - the user controls a function
# 
# These groups are mutually exclusive.
# 
class User_Type < UserHelper::Enum
    enums %w(ADMINISTRATIVE ORGANISATIONAL FUNCTIONAL)
end
  

