#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
# TODO: The user contains an email address (which can be the first name and 
# surname) this is associated with the organisation or function that they are
# associated with.  Does this have a data protection implication???
#
class User < ActiveRecord::Base
  has_one :organisation
  has_one :function
  validates_presence_of :user_type,
    :message => 'User type is required'  
  validates_presence_of :passkey,
    :message => 'All users must have a passkey'  
  validates_presence_of :email, 
    :message => 'Please provide an email'
  validates_format_of :email,
    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :message => 'Email must be valid'
#
# A user may be one of three types. 
# * Administrative - the user has now function or organisation
# * Organisational - the user controls an organisation
# * Functional - the user controls a function
# These groups are mutually exclusive.
# 
  TYPE = {:administrative => 0, 
    :organisational => 1, 
    :functional => 2}
#
# There is no built in method for creating a GUID in Ruby so the UUID in
# MySql is called instead.  The UUID is designed as a number that is globally
# unique in space and time, but has predictable features, so it is probably
# not ideal as a passkey.
# 
# TODO: Ensure that the passkey is not predictable.
#   a. add a check bit so we can detect if it has been messed with
#
  def save
    email = read_attribute(:email)
    date = read_attribute(:created_on).nil? ? DateTime::now() : read_attribute(:created_on)
    number = rand(999999)
    key = Digest::SHA1.hexdigest(email.to_s + date.to_s + number.to_s)
    write_attribute(:passkey, key)
    super
  end
#
# Administrative users have no organisation or function to control. 
# 
  def self.find_admins
    find(:all, :conditions => {:user_type => User::TYPE[:administrative]})
  end
# 
# TODO: if the user "email" of the user has changed then the "reminded_on"
# date should be set to null.  Because the reminder is when the user was
# reminded so is no longer valid if it is a new user.
# 
end

  

