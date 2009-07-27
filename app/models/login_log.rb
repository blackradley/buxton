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
      data = /['|"]mailto:(\S*)['|"]/.match(self.message)[1].gsub('"', '').gsub("'", '')
      det[:user] = data
      if message.include?('activity approver')
        level_manager = ActivityApprover
        level = [nil,'activity']
        det[:level] = 'activity'
      else
        level = /<\/a>, (\S*) manager/.match(self.message)
        det[:level] = level[1].to_s.titleize
        level_manager = "#{level[1].camelcase}Manager".constantize
      end
      det[:organisation] = level_manager.find_by_email(data).send(level[1].to_sym) if User.find_by_email(data) && level_manager.find_by_email(data).send(level[1].to_sym)
      det[:action] = "Logged in"
      return det
    else
      data = /The activity creation screen for (.*) was viewed/.match(self.message)
      det[:user] = "Organisation Creator"
      det[:level] = "Organisation Creator"
      det[:organisation] = data[1].titleize
      det[:action] = "Logged in"
      return det
    end
  end
end