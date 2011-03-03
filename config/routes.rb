#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
Buxton::Application.routes.draw do
  resources :organisations do
    resources :strategies do
      collection do
        get :reorder
        post :update_strategy_order
      end
    end

    resources :directorates do
      collection do
        get :view_pdf
      end    
    end

    resources :projects
  end
  
  resources :activities do
    collection do
      post :update_name
      post :update_ces
      get :questions
      get :show
      post :update_approver
      post :update_ref_no
      post :update_activity_type
      post :update
      get :toggle_strand
      get :submit
    end
    
    member do
      get :view_pdf
    end
  end
  
  resources :sections do
    collection do 
      post :update
    end
    
  end
  
  match 'view_pdf' => 'organisations#view_pdf', :as => :pdf
  resources :logs do
    collection do
      get :download
      post :clear
    end
  end

  resources :comment do
    collection do
      delete :destroy_strategy
      post :edit_strategy
      post :set_comment
    end
  end
  resources :note do
    collection do
      delete :destroy_strategy
      post :edit_strategy
      post :set_note
    end
  end
  match 'demos/new' => 'demos#new', :as => :new_demo, :via => :get
  match 'demos' => 'demos#create', :as => :demos, :via => :post
  match 'sections/edit/:id/:equality_strand' => 'sections#edit'
  match 'test_signup' => 'users#signup', :as => :test_signup
  match 'keys' => 'users#keys', :as => :keys if KEYS
  match 'signup' => 'users#signup', :as => :signup
  match 'logout' => 'users#logout', :as => :logout
  match 'sample_pdf' => 'users#sample_pdf', :as => :sample_pdf
  match '/' => 'users#index'
  # match '/:controller(/:action(/:id))'
  match ':passkey' => 'users#login', :constraints => { :passkey => /[a-f0-9]{40}i{0,1}/ }
end