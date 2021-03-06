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
    resources :issues
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
        get :edit_issue
        get :edit_full_assessment_comment
        post :add_new_issue
      end
    end
  end

  resources :activities do
    collection do
      get :directorate_eas
      get :my_eas
      get :quality_control
      get :approving
      get :autocomplete_user_email
      get :directorate_governance_eas
      post :generate_schedule
      get :assisting
      get :actions
      post :get_service_areas
    end

    member do
      get :questions
      get :delete
      post :submit
      post :clone
      post :toggle_strand
      get :approve
      get :reject
      get :summary
      get :reopen
      get :task_group
      get :add_task_group_member
      delete :remove_task_group_member
      post :create_task_group_member
      get :comment
      get :task_group_comment_box
      post :make_task_group_comment
      post :submit_comment
      post :submit_approval
      post :submit_rejection
      post :submit_reopen
      get :edit_tgm
      patch :update_tgm
    end
  end

  resources :users do
    collection do
      get :set_homepage
      get :access_denied
      get :new_user
    end

    member do
      post :toggle_user_status
      get :training
      post "training", :to => "users#update_training"
    end
  end

  match "access_denied", :to => "users#access_denied", via: :get
  root :to => "application#set_homepage"

  devise_for :user, :controllers => {:passwords => "passwords", :password_expired => "password_expired"}, :path_names => { :sign_in => 'login', :sign_out => 'logout'} #do
  #   get "login", :to => "devise/sessions#new"
  #   get "logout", :to => "devise/sessions#destroy"
  # end

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
      # get :autocomplete_creator_email
      # get :autocomplete_user_cop_email
    end

    member do
      post :toggle_directorate_status
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
  resources :strategies do
    member do
      post :toggle_retired_status
    end
  end

  match 'sections/edit/:id/:equality_strand' => 'sections#edit', via: :get
  # match '/:controller(/:action(/:id))'
end
