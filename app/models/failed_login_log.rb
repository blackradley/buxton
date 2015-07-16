#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class FailedLoginLog < Log
  ICON = 'icons/login.gif'

  def details
    det = LogDetails.new
    unless message.include?('activity creation screen')
      data = /mailto:(\S*)/.match(self.message)[1].gsub('"', '').gsub("'", '')
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
      det[:organisation] = level_manager.find_by(email: data).send(level[1].to_sym).name if level_manager.find_by(email: data) && level_manager.find_by(email: data).send(level[1].to_sym)
      det[:action] = "Logged in"
      det[:date] = self.created_at.strftime("%d/%m/%Y")
      det[:time] = self.created_at.strftime("%H:%M")
      return det
    else
      data = /The activity creation screen for (.*) was viewed/.match(self.message)
      det[:user] = "#{data[1].titleize} Organisation Creator"
      det[:level] = "Organisation Creator"
      det[:organisation] = data[1].titleize
      det[:action] = "Logged in"
      det[:date] = self.created_at.strftime("%d/%m/%Y")
      det[:time] = self.created_at.strftime("%H:%M")
      return det
    end
  end
end
