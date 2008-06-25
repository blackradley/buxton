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
  map.resources :organisations do |organisations|
    organisations.resources :strategies, :collection => { :reorder => :get, :update_strategy_order => :post }
    organisations.resources :directorates, :collection => {:view_pdf => :get}
    organisations.resources :projects
  end
  
  map.pdf 'view_pdf', :controller => 'organisations', :action => 'view_pdf'
  map.resources :logs, :collection => { :clear => :post }

  # Manually create a subset of the RESTful named routes for the DemosController
  map.new_demo 'demos/new', :controller => 'demos', :action => 'new', :conditions => { :method => :get }
  map.demos 'demos', :controller => 'demos', :action => 'create', :conditions => { :method => :post }

  map.connect 'sections/edit/:id/:equality_strand', :controller => 'sections', :action => 'edit'

  map.keys 'keys', :controller => 'users', :action => 'keys' if KEYS

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'users'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  # If all else fails, may be it's a passkey?
  # n.b. Passkeys that end in an i don't leave any audit trail
  map.connect ':passkey', :controller => 'users', :action => 'login', :requirements => {:passkey => /[a-f0-9]{40}i{0,1}/}
end
