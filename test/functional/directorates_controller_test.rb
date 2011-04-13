# #
# # $URL$
# # $Rev$
# # $Author$
# # $Date$
# #
# # Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
# #
# require File.dirname(__FILE__) + '/../test_helper'
# require 'directorates_controller'
# 
# # Re-raise errors caught by the controller.
# class DirectoratesController; def rescue_action(e) raise e end; end
# 
# class DirectoratesControllerTest < Test::Unit::TestCase
#   fixtures :directorates, :users, :organisations, :look_ups
#   def setup
#     @controller = DirectoratesController.new
#     @request    = ActionController::TestRequest.new
#     @response   = ActionController::TestResponse.new
#   end
# 
#   
#   def test_cannot_view_directorates_without_user
#     options = { :controller => 'directorates',
#                 :action => 'index',
#                 :organisation_id => '1' }
#     assert_routing('organisations/1/directorates', options)
#     
#     get :index, :organisation_id => 1
#     assert_redirected_to :controller => 'users'
#     get :show, :organisation_id => 1, :id => 1
#     assert_redirected_to :controller => 'users'
#     get :edit, :organisation_id => 1, :id => 1
#     assert_redirected_to :controller => 'users'
#     post :new, :organisation_id => 1
#     assert_redirected_to :controller => 'users'
#     post :create, :organisation_id => 1
#     assert_redirected_to :controller => 'users'
#     put :update, :organisation_id => 1, :id => 1
#     assert_redirected_to :controller => 'users'
#     delete :destroy, :organisation_id => 1, :id => 1
#     assert_redirected_to :controller => 'users'  
#   end
#   
#   def test_cannot_view_directorates_as_organisation_manager
#     login_as :organisation_manager
#     get :index, :organisation_id => 1
#     assert_redirected_to '/users/access_denied'
#     get :show, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#     get :edit, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#     post :new, :organisation_id => 1
#     assert_redirected_to '/users/access_denied'
#     post :create, :organisation_id => 1
#     assert_redirected_to '/users/access_denied'
#     put :update, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#     delete :destroy, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#   end
#   
#   def test_cannot_view_directorates_as_activity_manager
#     login_as :activity_manager
#     get :index, :organisation_id => 1
#     assert_redirected_to '/users/access_denied'
#     get :show, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#     get :edit, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#     post :new, :organisation_id => 1
#     assert_redirected_to '/users/access_denied'
#     post :create, :organisation_id => 1
#     assert_redirected_to '/users/access_denied'
#     put :update, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#     delete :destroy, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#   end
#   
#   def test_cannot_view_directorates_as_directorate_manager
#     login_as :directorate_manager
#     get :index, :organisation_id => 1
#     assert_redirected_to '/users/access_denied'
#     get :show, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#     get :edit, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#     post :new, :organisation_id => 1
#     assert_redirected_to '/users/access_denied'
#     post :create, :organisation_id => 1
#     assert_redirected_to '/users/access_denied'
#     put :update, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#     delete :destroy, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#   end
#   
#   def test_cannot_view_directorates_as_project_manager
#     login_as :project_manager
#     get :index, :organisation_id => 1
#     assert_redirected_to '/users/access_denied'
#     get :show, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#     get :edit, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#     post :new, :organisation_id => 1
#     assert_redirected_to '/users/access_denied'
#     post :create, :organisation_id => 1
#     assert_redirected_to '/users/access_denied'
#     put :update, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#     delete :destroy, :organisation_id => 1, :id => 1
#     assert_redirected_to '/users/access_denied'
#   end
#   
#   
#   # def test_can_view_directorates_as_administrator
#   #   login_as :administrator
#   #   get :index, :organisation_id => 1
#   #   assert_response :success
#   #   get :show, :organisation_id => 1, :id => 1
#   #   assert_response :success
#   #   get :edit, :organisation_id => 1, :id => 1
#   #   assert_response :success
#   #   post :new, :organisation_id => 1
#   #   assert_response :success
#   #   post :create, :organisation_id => 1, :directorate => [:id => 3, :name => "Test Directorate 3", :directorate_manager_id => 1]
#   #   assert_redirected_to organisation_directorates_url
#   #   put :update, :organisation_id => 1, :id => 1
#   #   assert_redirected_to organisation_directorates_url
#   #   delete :destroy, :organisation_id => 1, :id => 1
#   #   assert_redirected_to organisation_directorates_url
#   # end
# end