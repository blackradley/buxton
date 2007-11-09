# 
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
# 
# Each organisation is owned by a single user.  It is entirely possible that more
# than one user will want to edit the organisation or at least review the status
# of a Function.  The named user (identified by the email) could then pass the 
# "unique" URL on to anyone to mess about with.  Let's face it users tend to 
# hand out their passwords to anyone so you might as well accept the fact and
# live with it.
# 
# Like the function there has to be a valid User before you can create an organisation.
# The organisation has strategies (or priorities, call them what you will) which
# each of the functions will have to subscribe to.  This isn't really a many to many
# relationship, though I first sight I thought it was.
# 
# So that the users of each organisation can get a differently styled version of
# the application, each organisation has it's own style sheet.  The plan is to name
# each of the style sheets after the local authority, so the style sheet for 
# www.birmingham.gov.uk will be birmingham.css.  The style sheets will have to be
# hand crafted when each of the local authorities joins to become an organisation
# in the system.
# 
class Organisation < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  validates_presence_of :user
  validates_associated :user

  has_many :functions, :dependent => :destroy
  validates_associated :functions

  has_many :strategies, :dependent => :destroy
  validates_associated :strategies

  validates_presence_of :name, 
    :message => 'All organisations must have a name'
  validates_presence_of :style,
    :message => 'Please provide an css style name, all organisations must have a style'
  validates_format_of :style,
    :with => /^[\w\s\'\-]*$/i
end
