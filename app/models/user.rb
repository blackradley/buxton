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
require 'digest/sha1'

class User < ActiveRecord::Base
  validates_presence_of :type,
    :message => 'User type is required'
  validates_presence_of :email, 
    :message => 'Please provide an email'
  validates_format_of :email,
    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :message => 'E-mail must be valid'

  def before_create
    self.passkey = User.generate_passkey(self)
  end

  # Generate a new pass key.
  # There is no built in method for creating a GUID in Ruby so I have knocked
  # one up from the email, date and a random number.
  def self.generate_passkey(user)
    # If the user isn't valid then the attributes we need may not be available, abort
    return unless user.valid?
    
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
  
  # Generate a login URL for a given subdomain and passkey
  def url_for_login(request)
    domain = request.domain(TLD_LENGTH)

    subdomain = case self.class.name
    when 'ActivityManager'
      subdomain_string = self.activity.organisation.style + '.'
    when 'DirectorateManager'
      subdomain_string = self.directorate.organisation.style + '.'
    when 'OrganisationManager'
      subdomain_string = self.organisation.style + '.'
    when 'Administrator'
      subdomain_string = ''
    else
      # TODO throw an error - shouldn't ever get here
    end

    # unfortunately needed until we set up wildcard DNS on staging/dev server
    if domain == '27stars.co.uk' || domain == 'localhost'
      "#{request.protocol}#{request.host_with_port}/#{self.passkey}"
    else
      "#{request.protocol}#{subdomain_string}#{domain}#{request.port_string}/#{self.passkey}"
    end
  end
  
end