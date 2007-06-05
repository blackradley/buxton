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
  has_one :organisation, :dependent => :destroy
  has_one :function, :dependent => :destroy
  validates_presence_of :user_type,
    :message => 'User type is required'    
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
# Over ride the two save methods, adding the new key in on the way.
# 
# TODO: Review if this is a Ruby thing to do.
# 
  def save
    save_with_key
    super
  end
  
  def save!
    save_with_key
    super
  end
#
# There is no built in method for creating a GUID in Ruby so I have knocked
# one up from the email, date and a random number.
# 
# TODO: Review how secure the keys are.  They don't have to be bomb proof
# just secure enough.
# 
  private
  def save_with_key
    email = read_attribute(:email)
    date = read_attribute(:created_on).nil? ? DateTime::now() : read_attribute(:created_on)
    number = rand(999999)
    key = Digest::SHA1.hexdigest(email.to_s + date.to_s + number.to_s)
    write_attribute(:passkey, key)
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

  

