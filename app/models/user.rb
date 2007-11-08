# 
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
# Users are identified by their email address only.  No other information is 
# retained about the users so as to avoid data protection problems and to 
# minimize the amount of junk information we have to maintain.
#
# TODO: The user contains an email address (which can be the first name and 
# surname) this is associated with the organisation or function that they are
# associated with.  Does this have a data protection implication???
#
# TODO: if the user "email" of the user has changed then the "reminded_on"
# date should be set to null.  Because the reminder is when the user was
# reminded so is no longer valid if it is a new user.
# 
require 'digest/sha1'

class User < ActiveRecord::Base
  has_one :organisation, :dependent => :destroy
  has_one :function, :dependent => :destroy
  validates_presence_of :user_type,
    :message => 'User type is required'    
  validates_presence_of :email, 
    :message => 'Please provide an email'
  validates_format_of :email,
    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :message => 'E-mail must be valid'
#
# A user may be one of three types. 
# 
# * Administrative - the user has no function or organisation
# * Organisational - the user controls an organisation
# * Functional - the user controls a function
# 
# These groups are mutually exclusive.
# 
  TYPE = {:administrative => 0, 
    :organisational => 1, 
    :functional => 2}
#
# Administrative users have no organisation or function to control. 
# 
  def self.find_admins
    find(:all, :conditions => {:user_type => User::TYPE[:administrative]})
  end  
# 
# Generate a new pass key.
# There is no built in method for creating a GUID in Ruby so I have knocked
# one up from the email, date and a random number.
# 
  def self.generate_passkey(user)
    email = user.email
    date = user.created_on.nil? ? DateTime::now() : user.created_on
    number = rand(999999)
    passkey = Digest::SHA1.hexdigest(email.to_s + date.to_s + number.to_s)
    if User.find_by_passkey(passkey) then 
      User.generate_passkey(user)
    else
      return passkey
    end
  end
end