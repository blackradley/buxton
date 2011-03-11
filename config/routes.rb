#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
Buxton::Application.routes.draw do
  
  resources :activities do
    collection do
      get :directorate_einas
      get :my_einas
      get :assisting
      get :autocomplete_user_email
    end
    
    member do
      get :submit
      get :toggle_strand
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
  
  resources :users do    
    collection do 
      get :set_homepage
      get :access_denied
    end
    
    member do
      get :training
      post "training", :to => "users#update_training"
    end
  end
  
  match "access_denied", :to => "users#access_denied"
  root :to => "application#set_homepage"

  devise_for :user, :path_names => { :sign_in => 'login', :sign_out => 'logout'} do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end
  
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
  resources :issues
  
  match 'sections/edit/:id/:equality_strand' => 'sections#edit'
  # match '/:controller(/:action(/:id))'
end