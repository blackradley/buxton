#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class GraphsController < ApplicationController

  def progress_chart
    acts = @current_user.activities
    incomplete = acts.find_all_by_approved("not submitted", :order => 'name')
    awaiting_approval = acts.find_all_by_approved("submitted", :order => 'name')
    approved = acts.find_all_by_approved("approved", :order => 'name')
    
    data = []
    unless incomplete.empty?
      data << ['Incomplete', incomplete.size, {:controller => 'activities', :action => 'incomplete'}]
    end
    unless awaiting_approval.empty?
      data << ['Awaiting Approval', awaiting_approval.size, {:controller => 'activities', :action => 'awaiting_approval'}]
    end
    unless approved.empty?
      data << ['Approved', approved.size, {:controller => 'activities', :action => 'approved'}]
    end
  
    total = data.inject(0){|sum, d| sum + d[1]}
    percentages, labels, links = [], [], []
  
    data.each do |d|
      percentages << ((d[1].to_f / total)*100).round
      labels << d[0]
      links << url_for(d[2])
    end

    g = Graph.new
    g.pie(60, '#505050', '{font-size: 12px; color: #000000;}')
    g.pie_values(percentages, labels, links)
    g.pie_slice_colors(%w(#d01fc3 #356aa0 #c79810))
    g.set_bg_color('#ffffff')
    g.set_tool_tip("#val#%")
    g.title("Activities' Status", '{font-size:14px; color: #000000; padding: 15px;}' )
    render :text => g.render
  end

end