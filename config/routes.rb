#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
Buxton::Application.routes.draw do
  devise_for :admins

  devise_for :users

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
      post :update_approver
      post :update_ref_no
      post :update
      get :toggle_strand
      get :submit
    end
    
    member do
      get :view_pdf
      get :old_index
      get :questions
      post :update_activity_type
    end
  end
  
  resources :sections do
    collection do 
      post :update
    end
    
  end
  
  devise_for :users do
   get 'users', :to => 'users#show', :as => :user_root # Rails 3
  end
  
  devise_for :admin
  
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
  match 'login'  => 'login#new',     :as => :login
  match 'signin' => "login#create",  :as => :signin
  match 'logout' => 'login#destroy', :as => :logout
  match 'unauthenticated' => 'login#unauthenticated', :as => :unauthenticated
  resources :issues
  match 'demos/new' => 'demos#new', :as => :new_demo, :via => :get
  match 'demos' => 'demos#create', :as => :demos, :via => :post
  match 'sections/edit/:id/:equality_strand' => 'sections#edit'
  match 'keys' => 'users#keys', :as => :keys if KEYS
  match 'sample_pdf' => 'users#sample_pdf', :as => :sample_pdf
  # match '/:controller(/:action(/:id))'
  # 
  match ':passkey' => 'users#login', :constraints => { :passkey => /[a-f0-9]{40}i{0,1}/ }
end