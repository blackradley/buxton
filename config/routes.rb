#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
Buxton::Application.routes.draw do
  
  namespace :activities do
    resources :sections do
      member do
        get :edit_purpose_a
        get :edit_purpose_b
        get :edit_purpose_c
        get :edit_purpose_d
        get :edit_impact
        get :edit_consultation
        get :edit_additional_work
        get :edit_action_planning
        get :new_issue
        get :edit_full_assessment_comment
      end
    end
  end

  resources :activities do
    collection do
      get :directorate_einas
      get :my_einas
      get :approving
      get :autocomplete_user_email
    end
    
    member do
      get :questions
      get :submit
      post :toggle_strand
      get :approve
      get :reject
      post :submit_approval
      post :submit_rejection
    end
  end
  
  resources :users do    
    collection do 
      get :set_homepage
      get :access_denied
    end
    
    member do
      post :toggle_user_status
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
  
  resources :directorates do
    collection do
      get :autocomplete_user_email
      get :autocomplete_creator_email
    end
  end
  
  resources :service_areas do
    collection do 
      get :autocomplete_user_email
    end    
    member do
      post :toggle_retired_status
    end
  end
  resources :strategies
  
  match 'sections/edit/:id/:equality_strand' => 'sections#edit'
  # match '/:controller(/:action(/:id))'
end