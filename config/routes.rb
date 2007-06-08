#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
# 
ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Named route:
  # map.home '', :controller => 'shit', :action => 'shit'
 
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action'
  map.connect ':passkey', :controller => 'user', :action => 'login'
  map.connect '', :controller => 'user', :action => 'demo_organisation'
end
