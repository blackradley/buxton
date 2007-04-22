#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
class User < ActiveRecord::Base
  has_one :organisation
  has_one :function
  validates_presence_of :email  
  validates_format_of :email,
  :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
  :message => 'email must be valid'
#
# A user may be one of three types. 
# * Administrative - the user has now function or organisation
# * Organisational - the user controls an organisation
# * Functional - the user controls a function
# These groups are mutually exclusive.
# 
  ADMINISTRATIVE = 0
  ORGANISATIONAL = 1
  FUNCTIONAL = 2
#
# There is no built in method for creating a GUID in Ruby so the UUID in
# MySql is called instead.  The UUID is designed as a number that is globally
# unique in space and time, but has predictable features, so it is probably
# not ideal as a passkey.
# 
# TODO: Ensure that the passkey is not predictable.
#   a. remove the dashes so it doesn't look like a GUID
#   b. add a random number (in hex) so it is not predictable
#   c. add a check bit so we can detect if it has been messed with
#
  def self.new_passkey
    return ActiveRecord::Base.connection.select_one('select UUID()')['UUID()']
  end  
#
# Administrative users have no organisation or function to control. 
# 
  def self.find_admins
    find(:all, :conditions => "User_Type = #{ADMINISTRATIVE}")
  end
  
end

  

