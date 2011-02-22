# #  
# # $URL$
# # $Rev$
# # $Author$
# # $Date$
# #
# # Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
# #
require File.dirname(__FILE__) + '/../test_helper'
require 'sections_controller'
# 
# Re-raise errors caught by the controller.
class SectionsController; def rescue_action(e) raise e end; end

class SectionsControllerTest < Test::Unit::TestCase
  fixtures :activities, :users, :organisations, :look_ups, :activities_projects, :terminologies, :organisation_terminologies, :projects
  
  def setup
    @controller = SectionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # A simple test that calls all public actions via all http actions and uses some dummy parameters.
  # There are no assertions in this test, because we don’t know if an action should succeed or redirect.
  # The only thing checked with in this test is that the action does not fail.
  def test_garbage
    ac = ApplicationController.new
    @controller.public_methods.each do |action|
      unless ac.respond_to?(action)
        [:get, :post, :head, :put, :delete].each do |http_method|
          [nil, '', 'abc'*80, '-23', '123456789012345'].each do |param|
            method(http_method).call(action, :id => param)
          end
        end
      end
    end
  end
  
  def test_cannot_view_activities_without_user    
    post :list
    assert_redirected_to :controller => 'users'
    get :show
    assert_redirected_to :controller => 'users'
    get :edit
    assert_redirected_to :controller => 'users'
    post :update
    assert_redirected_to :controller => 'users'
  end
  
  def test_cannot_view_activities_as_organisation_manager
    login_as :organisation_manager
    get :edit
    assert_redirected_to '/users/access_denied'
    post :update
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_activities_as_activity_manager
    login_as :activity_manager
    post :list
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_activities_as_directorate_manager
    login_as :directorate_manager
    post :list
    assert_redirected_to '/users/access_denied'
    get :show
    assert_redirected_to '/users/access_denied'
    get :edit
    assert_redirected_to '/users/access_denied'
    post :update
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_activities_as_project_manager
    login_as :project_manager
    post :list
    assert_redirected_to '/users/access_denied'
    get :show
    assert_redirected_to '/users/access_denied'
    get :edit
    assert_redirected_to '/users/access_denied'
    post :update
    assert_redirected_to '/users/access_denied'
  end
  
  
  def test_cannot_view_activities_as_administrator
    login_as :administrator
    post :list
    assert_redirected_to '/users/access_denied'
    get :show
    assert_redirected_to '/users/access_denied'
    get :edit
    assert_redirected_to '/users/access_denied'
    post :update
    assert_redirected_to '/users/access_denied'
  end
  
  # def test_cannot_view_activities_with_wrong_activity_manager
  #   login_as :activity_manager_2
  #   [:index, :show, :questions, :update, :update_activity_type, :update_name, :update_ref_no, :update_approver].each do |method|
  #     post method
  #     assert_redirected_to '/users/access_denied'
  #   end
  # end
  
  # def test_cannot_view_activities_with_wrong_organisation_manager
  #   login_as :organisation_manager_2
  #   post :show, :f => 1, :id => 'impact'
  #   assert_redirected_to '/users/access_denied'
  # end
  
  # 
  # def test_can_view_activities_with_right_activity_manager
  #   login_as :activity_manager
  #   get :show, :id => 'impact'
  #   assert_redirected_to :id => 'purpose'
  #   get :edit
  #   assert_response :success
  #   post :update
  #   assert_response :success
  # end
  
  # def test_can_view_activities_with_right_organisation_manager
  #   login_as :organisation_manager
  #   post :list
  #   assert_redirected_to :id => 'purpose'
  #   get :show, :f => 1, :id => 'impact'
  #   assert_redirected_to :id => 'purpose'
  # end
  
  
  
  
  
  
  
  
  
  
  
#   
#   def test_should_render_all_edit_sections_okay
#     login_as :activity_manager
#     
#     equality_strands = [ :gender, :race, :disability, :faith, :sexual_orientation, :age ]
#     all_es_sections = [ :impact, :confidence, :additional_work, :action_planning ]
#     
#     for section in all_es_sections
#       for es in equality_strands
#         get :edit, {:id => section, :equality_strand => es }
#         assert_response :success
#       end
#     end
#     
#     # Stragglers
#     get :edit, {:id => 'purpose', :equality_strand => 'overall' }
#     assert_response :success
#     get :edit, {:id => 'impact', :equality_strand => 'overall' }
#     assert_response :success
#   end
#   
#   def test_should_render_all_show_sections_okay_for_activity_manager
#     login_as :activity_manager
# 
#     es_sections = [ :purpose, :impact, :confidence, :additional_work, :action_planning ]
# 
#     for section in es_sections
#       get :show, :id => section
#       assert_response :success
#     end
#   end
# 
#   def test_should_render_all_show_sections_okay_for_organisation_manager
#     login_as :organisation_manager
# 
#     es_sections = [ :purpose, :impact, :confidence, :additional_work, :action_planning ]
# 
#     for function in OrganisationManager.find(session[:user_id]).organisation.functions
#       for section in es_sections
#         get :show, { :id => section, :f => function.id }
#         assert_response :success
#       end
#     end
#   end
# 
#   def test_should_render_all_list_sections_okay
#     login_as :organisation_manager
# 
#     es_sections = [ 'purpose', 'impact', 'confidence', 'additional_work', 'action_planning' ]
# 
#     for section in es_sections
#       get :list, :id => section
#       assert_response :success
#     end
#   end
#   
#   def test_should_update_section
#     login_as :activity_manager
#     get :edit #hack, see: http://blog.readum.com/2007/10/2/rails-2-0-nil-rewrite-error
#     location = url_for(:action => 'edit', :id => 'purpose', :section => 'overall')
#     @request.env['HTTP_REFERER'] = location
#     post :update
#     assert_response :redirect
#     assert_redirected_to location    
#   end
# 
end
