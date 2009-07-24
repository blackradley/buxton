#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class LoginLog < Log  
  ICON = 'icons/login.gif'
  
  def details
    det = {}
    unless message.include?('activity creation screen')
      data = /<a href='mailto:(\S*)'>email@email.com<\/a>, activity manager of <strong>(\S*)<\/strong> for <strong>(\S*)<\/strong> logged in./.match(self.message)
      det[:user] = data[1]
      det[:level] = User.find_by_email(data[1]).class.to_s.titleize
      det[:organisation] = User.find_by_email(data[1]).organisation if User.find_by_email(data[1]) && User.find_by_email(data[1]).organisation
      det[:action] = "Logged in"
      return User.find_by_email('joe@27stars.co.uk')
    else
      data = /The activity creation screen for (.*) was viewed/.match(self.message)
      det[:user] = "Organisation Creator"
      det[:level] = "Organisation Creator"
      det[:organisation] = data[1].titleize
      det[:action] = "Logged in"
    end
  end
end