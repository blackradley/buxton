#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  map.connect 'sections/edit/:id/:equality_strand', :controller => 'sections', :action => 'edit'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action'
  map.connect ':passkey', :controller => 'users', :action => 'login', :requirements => {:passkey => /[a-f0-9]{40}/}
  # Default to showing the login page
  map.connect '', :controller => 'users'
end